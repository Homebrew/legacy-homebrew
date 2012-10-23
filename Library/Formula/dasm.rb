require 'formula'

class Dasm < Formula
  homepage 'http://dasm-dillon.sourceforge.net'
  url 'http://sourceforge.net/projects/dasm-dillon/files/dasm-dillon/2.20.11/dasm-2.20.11.tar.gz'
  sha1 '6c1f0091e88fff8f814a92304286c1875fd64693'

  def install
    system "make"
    prefix.install 'bin', 'doc'
  end
end
