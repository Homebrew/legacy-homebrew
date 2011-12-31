require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.2.1.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 'e99e208eedc8bb42136c0077b6cfc5c0'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
