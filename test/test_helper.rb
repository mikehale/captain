require 'captain'
require 'test/unit'
require 'flexmock/test_unit'
require 'shoulda/test_unit'

if $stdout.tty? || ENV.has_key?('AUTOTEST')
  require 'redgreen'
end