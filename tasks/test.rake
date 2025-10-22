require 'rake/testtask'

names = []
FileList.new.include('test/**/*_test.rb').each do |path|
  name = "test_#{path[0..-9].split('/').last}"
  names << name
  Rake::TestTask.new(name) do |t|
    t.test_files  = [path]
    t.description = "Run tests in #{path}"
  end
end

desc "Run all the test tasks: #{names.join(', ')}"
task test: [*names]