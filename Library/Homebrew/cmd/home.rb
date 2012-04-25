module Homebrew extend self
  def home
    if ENV['BROWSER']
      browser_command = ENV['BROWSER']
    else
      browser_command = "open"
    end
    if ARGV.named.empty?
      exec browser_command, HOMEBREW_WWW
    else
      exec browser_command, *ARGV.formulae.map{ |f| f.homepage }
    end
  end
end
