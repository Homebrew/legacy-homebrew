module Homebrew
  def version
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.each do |f|
      puts "#{f.name} #{f.version}"
    end
  end
end
