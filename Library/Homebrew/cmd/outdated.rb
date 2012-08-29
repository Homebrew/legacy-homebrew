require 'formula'
require 'keg'

module Homebrew extend self
  def outdated
    outdated_brews do |f|
      if $stdout.tty? and not ARGV.flag? '--quiet'
        versions = f.rack.subdirs.map { |d| Keg.new(d) }.map { |keg| keg.basename }
        puts "#{f.name} (#{versions*', '} < #{f.version})"
      else
        puts f.name
      end
    end
  end

  def outdated_brews
    HOMEBREW_CELLAR.subdirs.reject { |d| d.subdirs.empty? }.map do |rack|
      f = Formula.factory(rack.basename.to_s) rescue nil
      next if f.nil?

      kegs = rack.subdirs.map { |d| Keg.new(d) }
      unless kegs.any? { |keg| keg.version >= f.version }
        yield f if block_given?
        f
      end
    end.compact
  end
end
