require 'formula'

class Aimage < Formula
  url 'http://afflib.org/downloads/aimage-3.2.5.tar.gz'
  homepage 'http://afflib.org/software/aimage-the-advanced-disk-imager'
  md5 '07a11d653cdd1d7a5aefe4d99cdbd408'

  depends_on 'afflib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
