require 'formula'
require 'keg'

module Homebrew
  def outdated
    outdated_brews do |f, versions|
      if ($stdout.tty? || ARGV.verbose?) and not ARGV.flag? '--quiet'
        puts "#{f.name} (#{versions*', '} < #{f.pkg_version})"
      else
        puts f.name
      end
    end
  end

  def outdated_brews
    Formula.installed.map do |f|
      versions = f.rack.subdirs.map { |d| Keg.new(d).version }.sort!
        if versions.all? { |version| f.pkg_version > version }
        yield f, versions if block_given?
        f
      end
    end.compact
  end
end
