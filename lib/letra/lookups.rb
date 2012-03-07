class Letra
  class Lookups
    attr_accessor :font, :lookups
    def self.for(font)
      Letra::Lookups.new(font).load
    end

    def initialize(font)
      self.font = font
      self.lookups = {}
    end

    def load
      script = File.expand_path('views/lookups.pe', File.dirname(__FILE__))
      file = Tempfile.new('lookups')
      begin
        `fontforge -lang=ff -script #{script} #{font} 2>/dev/null > #{file.path}`
        find_lookups_in(file)
      ensure
        file.close
        file.unlink
      end
      return self.lookups
    end

    def find_lookups_in(file)
      raw = file.read
      data = raw.scan /'(?<tag>....)' (?<name>.*) lookup /
      data.each do |d|
        self.lookups[d[0]] = d[1]
      end
    end
  end
end
