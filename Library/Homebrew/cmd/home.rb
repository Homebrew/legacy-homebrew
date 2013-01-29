module Homebrew extend self
  def home
    if ARGV.named.empty?
      exec_browser HOMEBREW_WWW
    else
      exec_browser *ARGV.formulas.map{ |f| f.homepage }
    end
  end
end
