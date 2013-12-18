require 'formula'

class Daq < Formula
  homepage 'http://www.snort.org/'
  url 'http://www.snort.org/dl/snort-current/daq-2.0.1.tar.gz'
  sha1 '63431274e868195a8c4efb064b204aa5a151d387'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
