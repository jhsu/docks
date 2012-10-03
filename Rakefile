require 'rake/testtask'

task :default do
  path = "./test/projects"
  FileUtils.rm_rf(path) if File.exists?("./test/projects")
  Dir::mkdir("./test/projects")
  Rake::Task['test'].invoke
  FileUtils.rm_rf(path)
end

Rake::TestTask.new do |t|
  t.name = "test"
  t.libs << "test" << "lib"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
