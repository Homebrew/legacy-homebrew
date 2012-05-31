require 'formula'

class LcdfTypetools < Formula
  url 'http://www.lcdf.org/type/lcdf-typetools-2.92.tar.gz'
  homepage 'http://www.lcdf.org/type/'
  sha256 'a7a9eeab572f4f392870f6e70e291235af18633b30ac179342efb5e99b426860'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make install"
  end
end
