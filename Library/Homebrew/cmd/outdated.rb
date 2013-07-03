require 'formula'
require 'keg'

module Homebrew extend self
  def outdated
    outdated_brews do |f, versions|
      if $stdout.tty? and not ARGV.flag? '--quiet'
        puts "#{f.name} (#{versions*', '} < #{f.version})"
      else
        puts f.name
      end
    end
  end

  def outdated_brews
    Formula.installed.map do |f|
      versions = f.rack.subdirs.map { |d| Keg.new(d).version }.sort!
      if versions.all? { |version| f.version > version }
        yield f, versions if block_given?
        f
      end
    end.compact
  end
end
