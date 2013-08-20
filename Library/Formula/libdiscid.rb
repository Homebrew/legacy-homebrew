require 'formula'

class Libdiscid < Formula
  homepage 'http://musicbrainz.org/doc/libdiscid'
  url 'http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.5.2.tar.gz'
  sha1 '445f2e1dc9bdf7effffdcc913424958b7cef1ae7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
