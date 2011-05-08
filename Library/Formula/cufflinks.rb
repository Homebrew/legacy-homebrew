require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-0.9.3.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  md5 '8a7cf406d0a3f97d79972b69dbab2122'

  depends_on 'boost'
  depends_on 'samtools'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
