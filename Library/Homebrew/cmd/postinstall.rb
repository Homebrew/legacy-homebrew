module Homebrew
  def postinstall
    ARGV.formulae.each { |f| f.run_post_install }
  end
end
