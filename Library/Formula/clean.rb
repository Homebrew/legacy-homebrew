require 'formula'

class Clean < Formula
  homepage 'http://clean.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/clean/clean/3.4/clean-3.4.tar.bz2'
  sha1 '3ce2e455eadec2f212e40102137a3c70ffa915c9'

  def install
    system 'make'
    bin.install 'clean'
    man1.install 'clean.1'
  end
end
