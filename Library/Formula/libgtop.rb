require 'formula'

class Libgtop < Formula
  homepage 'http://library.gnome.org/devel/libgtop/stable/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgtop/2.28/libgtop-2.28.5.tar.xz'
  sha1 '7104a7546252e3fb26d162e9b34e1f7df42236d1'

  bottle do
    sha1 "8e805527961a5880ee4b23ab0d0d4bb61f416bbd" => :mavericks
    sha1 "ec23946232ea0e8f47d85d42bc0315399e266bca" => :mountain_lion
    sha1 "5a2ab28aef2fe82fc0a6a54d6f5714d666da202e" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make install"
  end
end
