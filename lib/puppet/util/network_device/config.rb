require 'puppet/util/loadedfile'
require 'puppet/util/network_device'
require 'puppet/util/network_device/device'

class Puppet::Util::NetworkDevice::Config < Puppet::Util::LoadedFile

  def self.main
    @main ||= self.new
  end

  def self.devices
    main.devices || []
  end

  attr_reader :devices

  def exists?
    FileTest.exists?(@file)
  end

  def initialize()
    @file = Puppet[:deviceconfig]

    raise Puppet::DevError, "No device config file defined" unless @file
    return unless self.exists?
    super(@file)
    @devices = {}

    read(true) # force reading at start
  end

  # Read the configuration file.
  def read(force = false)
    return unless FileTest.exists?(@file)

    parse if force or changed?
  end

  private

  def parse
    begin
      devices = {}
      device = nil
      fd = File.open(@file)
      fd.each do |line|
        case line
        when /^\s*(#|$)/  # skip blank lines and comments
          next
        when /^\[([\w.-]+)\]\s*$/ # [device.fqdn]
          name = $1
          name.chomp!
          raise Puppet::Error, "Duplicate device found at line #{fd.lineno}" if devices.include?(name)
          device = Puppet::Util::NetworkDevice::Device.new(name, fd.lineno)
          devices[name] = device
          Puppet.debug "Found device: #{device.name} at #{device.line}"
        when /^\s*(type|url|debug)(\s+(.+))*$/
          parse_directive(device, $1, $3, fd.lineno)
        else
          raise Puppet::Error, "Invalid line #{fd.lineno}: #{line}"
        end
      end
    rescue Errno::EACCES => detail
      Puppet.err "Configuration error: Cannot read #{@file}; cannot serve"
    rescue Errno::ENOENT => detail
      Puppet.err "Configuration error: '#{@file}' does not exit; cannot serve"
    end

    @devices = devices
  end

  def parse_directive(device, var, value, count)
    case var
    when "type"
      device.provider = value
    when "url"
      device.url = value
    when "debug"
      device.debug = true
    else
      raise Puppet::Error, "Invalid argument '#{var}' at line #{count}"
    end
  end

end
