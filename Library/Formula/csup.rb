require 'formula'

class Csup < Formula
  homepage 'https://bitbucket.org/mux/csup'
  url 'https://bitbucket.org/mux/csup/get/REL_20120305.tar.gz'
  md5 '24be262075ce8f268caf86ffe20fe268'
  head 'https://bitbucket.org/mux/csup', :using => :hg

  def install
    system "make"
    bin.install "csup"
    man1.install "csup.1"
  end

  def test
    system "#{bin}/csup", "-v"
  end
end
