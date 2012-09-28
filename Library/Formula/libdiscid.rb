require 'formula'

class Libdiscid < Formula
  homepage 'http://musicbrainz.org/doc/libdiscid'
  url 'http://users.musicbrainz.org/~matt/libdiscid-0.2.2.tar.gz'
  sha1 '103ead94eeb8bea04ad92ab15ed6832be9b3fad9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
