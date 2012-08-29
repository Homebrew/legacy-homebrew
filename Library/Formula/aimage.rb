require 'formula'

class Aimage < Formula
  homepage 'http://afflib.org/archives/tag/aimage'
  url 'http://pkgs.fedoraproject.org/repo/pkgs/aimage/aimage-3.2.5.tar.gz/07a11d653cdd1d7a5aefe4d99cdbd408/aimage-3.2.5.tar.gz'
  md5 '07a11d653cdd1d7a5aefe4d99cdbd408'

  depends_on 'afflib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
