require 'formula'

class Cake <Formula
  url "git://github.com/ninjudd/cake.git"
  head "git://github.com/ninjudd/cake.git", :using => :git
  homepage "http://github.com/ninjudd/cake"
  version "0.6.2"

  def install
    bin.install "bin/cake"
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end