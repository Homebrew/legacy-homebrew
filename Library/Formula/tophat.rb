require 'formula'

class Tophat < Formula
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-1.3.1.tar.gz'
  homepage 'http://tophat.cbcb.umd.edu/'
  md5 'c6e39c7935fd6c7b43a80db3a179a537'

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
