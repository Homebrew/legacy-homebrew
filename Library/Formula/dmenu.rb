require 'formula'

class Dmenu < Formula
  homepage 'http://tools.suckless.org/dmenu/'
  url 'http://dl.suckless.org/tools/dmenu-4.5.tar.gz'
  md5 '9c46169ed703732ec52ed946c27d84b4'
  head 'http://hg.suckless.org/dmenu/'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/dmenu", "-v"
  end
end
