require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.0.3.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 '524f25fd96a49c09deda4b8525848ffe'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
