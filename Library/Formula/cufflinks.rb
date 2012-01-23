require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.2.0.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 '25a9cde0276b4d3d5f107cf7677a1668'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
