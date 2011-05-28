require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.0.2.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 'e1abc28602a304744cbbb471eb420d9a'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
