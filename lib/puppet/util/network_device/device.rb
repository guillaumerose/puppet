require 'uri'
require 'puppet/util/network_device'

class Puppet::Util::NetworkDevice::Device
  attr_reader :name, :line, :options, :url
  attr_accessor :provider

  def initialize(name, line)
    @name = name
    @line = line
    @options = { :debug => false }
  end

  def debug=(boolean)
    @options[:debug] = boolean
  end

  def url=(string)
    @url = URI.parse(string)
  end
end