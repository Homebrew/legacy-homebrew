require 'formula'

class HicolorIconTheme < Formula
  homepage 'http://icon-theme.freedesktop.org/wiki/HicolorTheme'
  url 'http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.13.tar.gz'
  sha1 '15e30dfcf5e7b53c1a6f9028c30665006abba55c'

  bottle do
    cellar :any
    sha1 "9cda7b4551999811e0fb8f31b9c662c595030476" => :mavericks
    sha1 "7e1aa09e4443379952647e8f4bfce0e62b7656da" => :mountain_lion
    sha1 "68da34eb7399f71cb6b8f109db36899b13b83172" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
