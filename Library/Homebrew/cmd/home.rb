module Homebrew
  def home
    if ARGV.named.empty?
      exec_browser HOMEBREW_WWW
    else
      exec_browser(*ARGV.formulae.map(&:homepage))
    end
  end
end
