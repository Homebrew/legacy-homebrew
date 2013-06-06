require 'formula'

class Atool < Formula
  homepage 'http://www.nongnu.org/atool/'
  url 'http://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz'
  sha1 '40865bdc533f95fcaffdf8002889eb2ac67224a9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
