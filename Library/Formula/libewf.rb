require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'http://libewf.googlecode.com/files/libewf-20130416.tar.gz'
  sha1 'b455412299fd15e7a4f1be670d886f99350bdae4'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
