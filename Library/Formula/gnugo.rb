require 'formula'

class Gnugo < Formula
  url 'http://ftp.cs.tu-berlin.de/pub/gnu/gnugo/gnugo-3.8.tar.gz'
  homepage 'http://www.gnu.org/s/gnugo/gnugo.html'
  md5 '6db0a528df58876d2b0ef1659c374a9a'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "gnugo --version"
  end
end
