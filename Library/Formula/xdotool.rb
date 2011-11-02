require 'formula'

class Xdotool < Formula
  url 'http://semicomplete.googlecode.com/files/xdotool-2.20110530.1.tar.gz'
  homepage 'http://www.semicomplete.com/projects/xdotool/'
  md5 '62d0c2158bbaf882a1cf580421437b2f'

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def test
    system "xdotool"
  end
end
