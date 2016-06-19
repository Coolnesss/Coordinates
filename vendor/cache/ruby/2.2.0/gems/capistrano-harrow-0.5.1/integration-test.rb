require 'capistrano/harrow'

if ARGV.length < 2
  $stderr.puts "Usage: test.rb <test-server-url> <git-config-file>\n"
  exit(1)
end

server = ARGV[0]
git_config = ARGV[1]

api = Capistrano::Harrow::API.new(
  url: server,
  client: Capistrano::Harrow::HTTP.new,
  participation_url: ENV.fetch('_CAPISTRANO_PARTICIPATION_URL', "#{server}/capistrano/participating"),
)
config = Capistrano::Harrow::Config::Git.new(git_config)
ui = Capistrano::Harrow::UI::TTY.new(timeout: 10)
installer = Capistrano::Harrow::Installer.new(ui: ui, config: config, api: api)
installer.install!
