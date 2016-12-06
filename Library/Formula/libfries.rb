require 'formula'

class Libfries < Formula
  url 'http://devel.cpl.upc.edu/freeling/downloads/14'
  homepage 'http://devel.cpl.upc.edu/freeling'
  md5 '1cf878f08a87f2fbfc4416f58fb8229f'
  version '1.2.1'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
