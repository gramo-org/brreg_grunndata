# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'brreg_grunndata'

module FixtureHelper
  def read_fixture(name)
    path = "#{__dir__}/fixtures/#{name}.xml"
    File.read path
  rescue Errno::ENOENT
    raise "No fixture file found at: #{path}"
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
