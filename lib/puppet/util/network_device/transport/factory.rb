require 'puppet/util/network_device/transport'

class Puppet::Util::NetworkDevice::Transport::Factory
  def self.create(url, debug)
    autoloader = Puppet::Util::Autoload.new(
      self,
      "puppet/util/network_device/transport",
      :wrap => false
    )

    if autoloader.load(url.scheme)
      transport = Puppet::Util::NetworkDevice::Transport.const_get(url.scheme.capitalize).new(debug || false)
      transport.host = url.host
      transport.port = url.port || case url.scheme ; when "ssh" ; 22 ; when "telnet" ; 23 ; end
      transport.user = url.user
      transport.password = url.password
    end
    transport
  end
end
