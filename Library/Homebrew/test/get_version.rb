#!/usr/bin/ruby
$:.push(File.expand_path(__FILE__+'/../..'))
require 'extend/pathname'

p = Pathname.new(ARGV[0])
v = p.version
puts v
