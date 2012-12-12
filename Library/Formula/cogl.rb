require 'formula'

class Cogl < Formula
  homepage 'http://wiki.clutter-project.org/wiki/Cogl'
  url 'http://ftp.gnome.org/pub/gnome/sources/cogl/1.12/cogl-1.12.0.tar.xz'
  sha256 '4e7b5abbf0a1e51d74618db1b513551e7c71b486e17e98373f4db93e7710e2f2'

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
