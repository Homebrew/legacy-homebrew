module Homebrew
  def __cellar
    if ARGV.named.empty?
      puts HOMEBREW_CELLAR
    else
      puts ARGV.formulae.map{ |f| HOMEBREW_CELLAR+f.name }
    end
  end
end
