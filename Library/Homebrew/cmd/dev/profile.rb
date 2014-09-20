begin
  require 'rubygems'
  require 'ruby-prof'
rescue LoadError
  abort 'This command requires the ruby-prof gem'
end

require 'formula'

module Homebrew
  def profile
    RubyProf.start
    Formula.names.each { |n| Formula.factory(n) }
    RubyProf::GraphHtmlPrinter.new(RubyProf.stop).print(STDOUT)
  end
end
