require 'formula'

class Tophat < Formula
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-1.4.0.tar.gz'
  homepage 'http://tophat.cbcb.umd.edu/'
  md5 'eb2c2f7d47358e199c79c64162636984'

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
