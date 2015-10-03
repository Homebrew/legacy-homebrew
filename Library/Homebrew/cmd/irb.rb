require "formula"
require "keg"
require "irb"

class Symbol
  def f(*args)
    Formulary.factory(to_s, *args)
  end
end
class String
  def f(*args)
    Formulary.factory(self, *args)
  end
end

module Homebrew
  def irb
    if ARGV.include? "--examples"
      puts "'v8'.f # => instance of the v8 formula"
      puts ":hub.f.installed?"
      puts ":lua.f.methods - 1.methods"
      puts ":mpd.f.recursive_dependencies.reject(&:installed?)"
    else
      ohai "Interactive Homebrew Shell"
      puts "Example commands available with: brew irb --examples"
      IRB.start
    end
  end
end
