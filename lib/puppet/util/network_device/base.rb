require 'puppet/util/network_device'

class Puppet::Util::NetworkDevice::Base
  attr_accessor :url, :transport

  def initialize(url, transport)
    @url = url
    @transport = transport
  end
end
