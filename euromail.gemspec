Gem::Specification.new do |s|
  s.name        = 'euromail'
  s.version     = '0.4.1'
  s.date        = '2013-07-30'
  s.summary     = "Gem to upload pdf data to an SFTP server"
  s.description = "Euromail SFTP service"
  s.authors     = ["Stefan Teijgeler"]
  s.email       = 'stefan.teijgeler@nedap.com'
  s.files       = Dir.glob('{lib,spec}/**/*')
  s.homepage    = 'https://github.com/steijgeler/euromail'

  s.add_runtime_dependency('net-sftp', '>= 2.1.2')
end
