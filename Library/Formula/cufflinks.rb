require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.2.1.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 '02d1428c9958fea545ab072e773dde4a'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
