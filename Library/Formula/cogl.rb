require 'formula'

class Cogl < Formula
  homepage 'http://developer.gnome.org/cogl/'
  url 'http://ftp.gnome.org/pub/gnome/sources/cogl/1.12/cogl-1.12.2.tar.xz'
  sha256 '31971d4c6543c589f6fc49ab1724dfbdc7062c58a7da842cb1935e32ca6e1d7e'

  head 'git://git.gnome.org/cogl'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'pango'
  depends_on 'cairo' # needs cairo-gobject
  depends_on :x11 if MacOS::X11.installed? or not build.include? 'without-x'

  def install
    system "./autogen.sh" if build.head?
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-introspection
    ]
    args << '--without-x' if build.include? 'without-x'
    system './configure', *args
    system "make install"
  end
end
