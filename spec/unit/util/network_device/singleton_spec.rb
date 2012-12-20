#! /usr/bin/env ruby
require 'spec_helper'

require 'puppet/util/network_device/singleton'
require 'puppet/util/network_device/device'

class Puppet::Util::NetworkDevice::Test
  class Device
    def initialize(device, transport, options)
    end
  end
end

describe Puppet::Util::NetworkDevice::Singleton do

  before(:each) do
    @device = Puppet::Util::NetworkDevice::Device.new("Fake name", 12)
    @device.provider = "test"
    @device.url = "telnet://admin:password@127.0.0.1"

    @transport = stub 'transport'
  end

  after(:each) do
    Puppet::Util::NetworkDevice::Singleton.teardown
  end

  describe "when initializing the remote network device singleton" do
    it "should create a network device instance" do
      Puppet::Util::NetworkDevice::Singleton.expects(:require)

      Puppet::Util::NetworkDevice::Transport::Factory.expects(:create).with(@device.url, false).returns(@transport)
      Puppet::Util::NetworkDevice::Test::Device.expects(:new).with(@device.url, @transport, @device.options)

      Puppet::Util::NetworkDevice::Singleton.init(@device)
    end

    it "should raise an error if the remote device instance can't be created" do
      Puppet::Util::NetworkDevice::Singleton.stubs(:require).raises("error")
      lambda { Puppet::Util::NetworkDevice::Singleton.init(@device) }.should raise_error
    end

    it "should let caller to access the singleton device" do
      device = stub 'device'

      Puppet::Util::NetworkDevice::Singleton.stubs(:require)
      Puppet::Util::NetworkDevice::Transport::Factory.stubs(:create).with(@device.url, false).returns(@transport)
      Puppet::Util::NetworkDevice::Test::Device.stubs(:new).with(@device.url, @transport, @device.options).returns(device)

      Puppet::Util::NetworkDevice::Singleton.init(@device)

      Puppet::Util::NetworkDevice::Singleton.current.should == device
    end

    it "should find the debug mode" do
      @device.debug = true

      Puppet::Util::NetworkDevice::Singleton.stubs(:require)
      Puppet::Util::NetworkDevice::Transport::Factory.expects(:create).with(@device.url, true).returns(@transport)
      Puppet::Util::NetworkDevice::Test::Device.expects(:new).with(@device.url, @transport, @device.options)

      Puppet::Util::NetworkDevice::Singleton.init(@device)
    end
  end
end
