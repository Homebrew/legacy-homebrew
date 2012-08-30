require 'formula'

class EasyTag < Formula
  homepage 'http://easytag.sourceforge.net'
  url 'http://sourceforge.net/projects/easytag/files/easytag%20%28gtk%202%29/2.1/easytag-2.1.7.tar.bz2'
  sha1 '7b56ba18be2f1bec0171e5de4447ba763a264f92'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'libid3tag'
  depends_on 'id3lib' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'speex' => :optional
  depends_on 'flac' => :optional
  depends_on 'mp4v2' => :optional
  depends_on 'wavpack' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make install"
  end
end
