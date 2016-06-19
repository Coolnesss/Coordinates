require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :integration do
  port = ENV.fetch('port', 12345).to_i
  sh %Q{
bundle exec -- ruby integration-test-server.rb -p #{port} > integration.log 2>&1 &
sleep 5
git config --unset harrow.session.uuid
yes longpassword | ruby -Ilib integration-test.rb http://localhost:#{port} .git/config
kill %1
}
end

task :default => :spec
