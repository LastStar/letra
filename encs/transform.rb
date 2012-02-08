class Set < Struct.new(:name, :characters)
  def save_to(dir)
    File.open("languages/#{name}", 'w') {|f| f.write(characters)}
  end
end

lines = IO.read('source').split("\n")
lines.each_slice(3) do |line|
  name = line[0].strip
  characters = line[1].delete(" ")
  set = Set.new(name, characters)
  set.save_to('languages')
end
