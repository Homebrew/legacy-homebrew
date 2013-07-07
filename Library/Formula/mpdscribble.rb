require 'formula'

class Mpdscribble < Formula
  homepage 'http://mpd.wikia.com/wiki/Client:Mpdscribble'
  url 'http://downloads.sourceforge.net/project/musicpd/mpdscribble/0.22/mpdscribble-0.22.tar.gz'
  sha1 '3b4a1a71130deea1720bbfeb104fdcae298f52de'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    The configuration file was placed in #{etc}/mpdscribble.conf
    EOS
  end
end
