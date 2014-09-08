require 'formula'

class Libwmf < Formula
  homepage 'http://wvware.sourceforge.net/libwmf.html'
  url 'https://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz'
  sha1 '822ab3bd0f5e8f39ad732f2774a8e9f18fc91e89'
  revision 1

  bottle do
    sha1 "5b106ee63e941401528165d3ea366b63f405ec09" => :mavericks
    sha1 "7f76a4c7d64e1a4bf44d4cec46b3c73b2127ce09" => :mountain_lion
    sha1 "08a60781f736ab6a5854e470cbc7d83f0eccce60" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'gd'
  depends_on 'freetype'
  depends_on 'libpng'
  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}"
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make install"
  end
end
