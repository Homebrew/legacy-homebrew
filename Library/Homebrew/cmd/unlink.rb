module Homebrew extend self
  def unlink
    ARGV.kegs.each do |keg|
      print "Unlinking #{keg}... "
      puts "#{keg.unlink} links removed"
    end
  end
end
