module Homebrew extend self
  def __cellar
    if ARGV.named.empty?
      puts HOMEBREW_CELLAR
    else
      puts ARGV.formulas.map{ |f| HOMEBREW_CELLAR+f.name }
    end
  end
end
