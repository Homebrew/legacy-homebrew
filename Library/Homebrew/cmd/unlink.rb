module Homebrew extend self
  def unlink
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.kegs.each do |keg|
      print "Unlinking #{keg}... "
      puts "#{keg.unlink} links removed"
    end
  end
end
