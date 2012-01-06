class Metlinkr
  def self.plan(from, to, options = nil)
    Journey.new(from, to, options).tap do |journey|
      journey.plan
    end
  end
end

$LOAD_PATH << File.dirname(__FILE__)
require 'metlinkr/version'
require 'metlinkr/journey'
require 'metlinkr/trip'
require 'metlinkr/step'

