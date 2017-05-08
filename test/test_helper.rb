require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'iamport'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true), Minitest::Reporters::RubyMineReporter.new]

IAMPORT_HOST = 'https://api.iamport.kr'.freeze
