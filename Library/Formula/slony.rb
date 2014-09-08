require 'formula'

class Slony < Formula
  homepage 'http://slony.info/'
  url 'http://slony.info/downloads/2.1/source/slony1-2.1.2.tar.bz2'
  sha1 '47449fbc742a25eefdab088ab650973416bccb53'

  depends_on :postgresql

  def install
    postgres = Formula['postgresql']
    system "./configure", "--disable-debug",
                          "--with-pgconfigdir=#{postgres.opt_bin}",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system bin/"slon", "-v"
  end
end
