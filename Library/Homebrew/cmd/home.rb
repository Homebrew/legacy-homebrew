module Homebrew extend self
  def home
    if ARGV.named.empty?
      exec "open", HOMEBREW_WWW
    else
      exec "open", *ARGV.formulae.map{ |f| f.homepage }
    end
  end
end
