require 'formula'

class Libdiscid < Formula
  homepage 'http://musicbrainz.org/doc/libdiscid'
  url 'http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.4.1.tar.gz'
  sha1 '256f5d4d7fcfb99a6bee92971bfd9f6da96e9639'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
