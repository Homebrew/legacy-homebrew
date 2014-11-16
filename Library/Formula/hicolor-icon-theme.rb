require 'formula'

class HicolorIconTheme < Formula
  homepage 'http://icon-theme.freedesktop.org/wiki/HicolorTheme'
  url 'http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.13.tar.gz'
  sha1 '15e30dfcf5e7b53c1a6f9028c30665006abba55c'

  bottle do
    cellar :any
    revision 1
    sha1 "9f3bd40e44a26a00b741f29fe86618a3cb8b570a" => :yosemite
    sha1 "930f46d4d40d82e17af141cbecaf5e51f5ccad09" => :mavericks
    sha1 "aa796a38b6672816314527f318d17f6bc6ad136b" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
