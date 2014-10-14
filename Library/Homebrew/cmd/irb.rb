require 'formula'
require 'keg'
require 'irb'

class Symbol
  def f
    Formulary.factory(to_s)
  end
end
class String
  def f
    Formulary.factory(self)
  end
end

module Homebrew
  def irb
    if ARGV.include? "--help"
      puts "'v8'.f # => instance of the v8 formula"
      puts ":hub.f.installed?"
      puts ":lua.f.methods - 1.methods"
      puts ":mpd.f.recursive_dependencies.reject(&:installed?)"
    else
      ohai "Interactive Homebrew Shell"
      puts "Example commands available with: brew irb --help"
      IRB.start
    end
  end
end
