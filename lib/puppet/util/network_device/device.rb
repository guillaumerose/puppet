class Puppet::Util::NetworkDevice::Device
  attr_reader :name, :line, :options
  attr_accessor :provider, :url

  def initialize(name, line)
    @name = name
    @line = line
    @options = { :debug => false }
  end

  def debug=(boolean)
    @options[:debug] = boolean
  end
end