require 'formula'

class EasyTag < Formula
  homepage 'http://projects.gnome.org/easytag'
  url 'http://ftp.gnome.org/pub/GNOME/sources/easytag/2.1/easytag-2.1.9.tar.xz'
  sha256 'f5a6e742a458ef6f48f2d5e98a24182a9c87a213e847fcce75c757ac90273501'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'itstool' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'
  depends_on 'id3lib'
  depends_on 'libid3tag'

  depends_on 'libvorbis' => :recommended
  depends_on 'flac' => :recommended
  depends_on 'libogg' if build.with? 'flac'

  depends_on 'mp4v2' => :optional
  depends_on 'speex' => :optional
  depends_on 'wavpack' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make install"
  end
end
