#! /usr/bin/env ruby
require 'spec_helper'

require 'puppet/provider/cisco'

describe Puppet::Provider::Cisco do
  it "should implement a device class method" do
    Puppet::Provider::Cisco.should respond_to(:device)
  end

  it "should create a cisco device instance" do
    device = stub 'device'
    Puppet::Util::NetworkDevice::Transport::Factory.expects(:create)
    Puppet::Util::NetworkDevice::Cisco::Device.expects(:new).returns device
    Puppet::Provider::Cisco.device("telnet://127.0.0.1").should == device
  end
end
