require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.3.0.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 '6914059cf8c8f22eb388e1fde44deabe'

  depends_on 'boost'
  depends_on 'samtools'

  fails_with :clang do
    build 421
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
