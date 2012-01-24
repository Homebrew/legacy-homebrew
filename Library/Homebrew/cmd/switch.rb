require 'formula'
require 'keg'

module Homebrew extend self
  def switch
    f = ARGV.shift
    version = ARGV.shift

    f = Formula.factory(f)
    raise "#{f.name} not installed" unless f.rack.exist? and not f.rack.children.empty?

    if f.rack.directory?
      versions = f.rack.children.select { |pn| pn.directory? }.collect { |pn| pn.basename.to_s }
      raise "#{f.name} #{version} is not installed" unless versions.include? version

      f.rack.children.each do |keg|
        if keg.directory?
          keg = Keg.new(keg)
          print "Unlinking #{keg}... "
          puts "#{keg.unlink} links removed"
        end
      end

      keg = Keg.new(f.rack+version)
      print "Linking #{keg}... "
      puts "#{keg.link} symlinks created"
    end
  end
end
