module Homebrew extend self
  def unlink
    ARGV.linked_kegs.each do |keg|
      print "Unlinking #{keg}... "
      puts "#{keg.unlink} links removed"
    end
  end
end
