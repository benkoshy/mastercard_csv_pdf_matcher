require "minitest/test_task"

Minitest::TestTask.create # named test, sensible defaults

# or more explicitly:

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task :default => :test


desc 'set up folder structure'
task :setup do
  unless File.directory?("./out/pdfs")
    FileUtils.mkdir_p(dirname)
  end

  unless File.directory?("./out/pdfs")
        FileUtils.mkdir_p(dirname)
  end
end
