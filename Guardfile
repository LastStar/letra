# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  # with Minitest::Unit
  watch(%r|^test/(.*)\/?test_(.*)\.rb|) { "test" }
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { "test" }
  watch(%r|^test/helper\.rb|)    { "test" }
end

guard 'ctags-bundler' do
  watch(%r|^lib/(.*)([^/]+)\.rb|)
  watch('Gemfile.lock')
end
