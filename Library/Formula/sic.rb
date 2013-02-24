require 'formula'

class Sic < Formula
  homepage 'http://tools.suckless.org/sic'
  url 'http://dl.suckless.org/tools/sic-1.1.tar.gz'
  sha1 '816d522758f6d04e6af6b7396c8077c32b2ddfb2'

  head 'http://hg.suckless.org/sic', :using => :hg

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
