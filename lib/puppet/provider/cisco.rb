require 'uri'

require 'puppet/provider/network_device'
require 'puppet/util/network_device/transport/factory'
require 'puppet/util/network_device/cisco/device'

class Puppet::Provider::Cisco < Puppet::Provider::NetworkDevice
  def self.device(url)
    uri = URI.parse(url)
    transport = Puppet::Util::NetworkDevice::Transport::Factory.create(uri)
    Puppet::Util::NetworkDevice::Cisco::Device.new(uri, transport)
  end
end
