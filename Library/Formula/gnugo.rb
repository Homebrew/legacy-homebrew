require 'formula'

class Gnugo < Formula
  homepage ''
  url 'http://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz'
  sha1 'a8ce3c7512634f789bc0c964fe23a5a6209f25db'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/gnugo", "--version"
  end
end
