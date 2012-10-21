require 'formula'

class Dmenu < Formula
  homepage 'http://tools.suckless.org/dmenu/'
  url 'http://dl.suckless.org/tools/dmenu-4.5.tar.gz'
  sha1 '70c1a13b950b7b0cb1bc35e30c6e861a78359953'
  head 'http://hg.suckless.org/dmenu/'

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/dmenu", "-v"
  end
end
