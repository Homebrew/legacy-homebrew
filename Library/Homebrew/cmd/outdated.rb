require 'formula'
require 'keg'

module Homebrew extend self
  def outdated
    outdated_brews do |f|
      if $stdout.tty? and not ARGV.flag? '--quiet'
        versions = f.rack.subdirs.map { |d| Keg.new(d).version }.sort
        puts "#{f.name} (#{versions*', '} < #{f.version})"
      else
        puts f.name
      end
    end
  end

  def outdated_brews
    Formula.installed.map do |f|
      kegs = f.rack.subdirs.map { |d| Keg.new(d) }
      unless kegs.any? { |keg| keg.version >= f.version }
        yield f if block_given?
        f
      end
    end.compact
  end
end
