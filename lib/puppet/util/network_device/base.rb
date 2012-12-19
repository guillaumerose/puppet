require 'puppet/util/autoload'
require 'uri'
require 'puppet/util/network_device/transport'
require 'puppet/util/network_device/transport/base'
require 'puppet/util/network_device/transport/factory'

class Puppet::Util::NetworkDevice::Base

  attr_accessor :url, :transport

  def initialize(url, options = {})
    @url = URI.parse(url)
    @transport = Puppet::Util::NetworkDevice::Transport::Factory.create(@url, options[:debug])
  end
end
