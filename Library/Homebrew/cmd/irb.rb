require 'formula'
require 'keg'
require 'irb'

class Symbol
  def f
    Formula.factory(self)
  end
end
class String
  def f
    Formula.factory(self)
  end
end

module Homebrew extend self
  def irb
    if ARGV.include? "--help"
      puts "'v8'.f # => instance of the Ack formula"
      puts ":hub.f.installed?"
      puts ":lua.f.methods - 1.methods"
      puts ":mpd.f.recursive_deps.reject{|f| f.installed? }"
    else
      ohai "Interactive Homebrew Shell"
      puts "Example commands available with: brew irb --help"
      IRB.start
    end
  end
end
