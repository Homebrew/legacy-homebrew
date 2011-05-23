require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.0.0.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 '64d6f1e60bab51d53d67e322a5e02b48'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
