require 'formula'

class Cufflinks < Formula
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-1.3.0.tar.gz'
  homepage 'http://cufflinks.cbcb.umd.edu/'
  sha1 'fa93a7a33f0649793ec1d185cb7043fd0dc2018b'

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
