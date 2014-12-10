module Homebrew
  def __prefix
    if ARGV.named.empty?
      puts HOMEBREW_PREFIX
    else
      puts ARGV.formulae.map{ |f| f.opt_prefix.exist? ? f.opt_prefix : f.installed_prefix }
    end
  end
end
