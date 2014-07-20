module Homebrew
  def __cellar
    if ARGV.named.empty?
      puts HOMEBREW_CELLAR
    else
      puts ARGV.formulae.map(&:rack)
    end
  end
end
