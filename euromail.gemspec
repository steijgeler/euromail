Gem::Specification.new do |s|
  s.name        = 'euromail'
  s.version     = '0.5.0'
  s.date        = '2014-08-29'
  s.summary     = "Gem to upload pdf data to an SFTP server"
  s.description = "Euromail SFTP service"
  s.authors     = ["Stefan Teijgeler"]
  s.email       = 'stefan.teijgeler@nedap.com'
  s.files       = Dir.glob('{lib,spec}/**/*')
  s.homepage    = 'https://github.com/steijgeler/euromail'
  s.license     = 'MIT'

  s.add_runtime_dependency('net-sftp', '>= 2.1.2')
end
