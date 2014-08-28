#!/usr/bin/env ruby

require 'optparse'
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: macchanger [mac address] [device]"

  opts.on("-r", "--random", "Set random mac address, macchanger -r en0") do |r|
    options[:random] = r
  end

  opts.on("-c", "--check", "Check mac address, macchanger -c en0") do |c|
    options[:check] = c
  end

end.parse!

class MacChanger

  def self.check(device)
    check = `ifconfig #{device} |grep ether`
    check[7,17]
  end

  def self.generate
    (1..6).map{"%0.2x"%rand(256)}.join(":")
  end

  def self.is_valid?(add)
    add.match(/^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$/)
  end

  def self.set(add, device, random=false)
    if MacChanger.is_valid? add
      if system("sudo ifconfig #{device} ether #{add}")
        if MacChanger.check(device) == add
          puts "Succesfuly setup #{add} on #{device} device"
        elsif random
          MacChanger.set(MacChanger.generate,device,true)
        else
          puts "Try another mac address"
        end
      end
    else
      raise ArgumentError, "Mac address is incorrect"
    end
  end
end

device = ARGV[0] or raise ArgumentError, "Device can't be blank"
if options[:check]
  puts "Your mac address is: #{MacChanger.check(device)}"
else
  if options[:random]
    add = MacChanger.generate
    random = true
  else
    add = ARGV[0] or raise ArgumentError, "Mac address can't be blank"
    device = ARGV[1] or raise ArgumentError, "Device can't be blank"
    random = false
  end
  MacChanger.set(add,device,random)
end
