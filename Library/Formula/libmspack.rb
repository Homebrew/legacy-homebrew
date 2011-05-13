require 'formula'

class Libmspack < Formula
  url 'http://www.cabextract.org.uk/libmspack/libmspack-0.3alpha.tar.gz'
  version '0.3alpha'
  homepage 'http://www.cabextract.org.uk/libmspack/'
  md5 '08d08455b6d58ea649b35febd23f6386'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
