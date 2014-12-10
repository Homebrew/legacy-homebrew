module Homebrew
  def postinstall
    ARGV.formulae.each {|f| f.post_install }
  end
end
