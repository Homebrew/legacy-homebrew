require 'formula'

class Tophat <Formula
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-1.2.0.tar.gz'
  homepage 'http://tophat.cbcb.umd.edu/'
  md5 '7ada78bdb9a84e13392418aa6cc9142c'

  depends_on 'samtools'

  def install
    # It seems this project Makefile doesn't like -j4
    # Disable until consult with upstream
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
