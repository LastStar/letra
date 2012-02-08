class Letra
  class EncBuilder
    def self.build_enc(options)
      languages = options[:languages].push('Basic set')
      custom    = options[:custom_characters]
      languages_path = File.expand_path('../../encs/languages', File.dirname(__FILE__))

      characters = []
      languages.each do |language|
        characters << IO.read(languages_path + "/" + language).scan(/./)
        characters.flatten!.uniq!
      end

      characters << custom.to_s.scan(/./)
      characters = characters.flatten.uniq

      characters = characters.join.unpack('U*')
    end
  end
end
