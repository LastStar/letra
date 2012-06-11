require 'reot'
require 'shellwords'

class Letra
  attr_accessor :destination, :fontfile, :name, :remove_kerning,
                :apply_substitutions, :reduce, :formats, :eot,
                :family, :subtype, :unique, :copyright

  def self.open(fontfile, &block)
    letra = Letra.new(fontfile)
    yield(letra)
    letra.work!
    letra.close
  end

  def initialize(fontfile)
    self.fontfile = fontfile
  end

  def work!
    self.eot = self.formats.delete(:eot)
    delete_ttf = !self.formats.include?(:ttf)
    self.formats << :ttf if self.eot
    self.formats.uniq!

    self.reduce =  Shellwords.escape(self.reduce) if self.reduce

    cmd = "python #{pytra_file}"
    cmd << " --remove-kerning" if self.remove_kerning
    cmd << " --keep-only #{self.reduce}" if self.reduce
    cmd << " --subs #{self.apply_substitutions.join(' ')}" if self.apply_substitutions
    cmd << " --formats #{self.formats.join(' ')}" if self.formats
    cmd << " --source #{self.fontfile}"
    cmd << " --destination #{self.destination}"
    cmd << " --name #{self.name}"
    cmd << " --family #{self.family}"
    cmd << " --subtype #{self.subtype}"
    cmd << " --unique '#{self.unique}'"
    cmd << " --copyright '#{self.copyright}'"

    if system(cmd)
      if self.eot
        Reot.convert!(generated_font_file('ttf'), generated_font_file('eot'))
        File.delete(generated_font_file('ttf')) if delete_ttf
      end
    else
      raise "Pytra failed"
    end
  end

  def pytra_file
    File.join(File.expand_path('..', __FILE__), 'pytra.py')
  end

  def close
  end

  def generated_font_file(extension)
    File.join(self.destination, "#{name}.#{extension}")
  end
end
