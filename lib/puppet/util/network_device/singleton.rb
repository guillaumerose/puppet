require 'uri'

require 'puppet/util/network_device'
require 'puppet/util/network_device/transport/factory'

class Puppet::Util::NetworkDevice::Singleton
  class << self
    attr_reader :current
  end

  def self.init(device)
    require "puppet/util/network_device/#{device.provider}/device"
    transport = Puppet::Util::NetworkDevice::Transport::Factory.create(device.url, device.options[:debug])
    @current = Puppet::Util::NetworkDevice.const_get(device.provider.capitalize).const_get(:Device).new(device.url, transport, device.options)
  rescue => detail
    raise "Can't load #{device.provider} for #{device.name}: #{detail}"
  end

  # Should only be used in tests
  def self.teardown
    @current = nil
  end
end
