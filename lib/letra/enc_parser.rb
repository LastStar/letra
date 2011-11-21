class Letra
  class EncParser
    def self.parse(input)
      return input.split("\n").collect {|line| line.split(" ").last.to_i }
    end
  end
end