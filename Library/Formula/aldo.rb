require 'formula'

class Aldo < Formula
  homepage 'http://www.nongnu.org/aldo/'
  url 'http://savannah.nongnu.org/download/aldo/aldo-0.7.7.tar.bz2'
  sha1 'c37589f8cb0855d33814b7462b3e5ded21caa8ea'

  depends_on 'libao'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
