require 'formula'

class Tsung < Formula
  url 'http://tsung.erlang-projects.org/dist/tsung-1.4.1.tar.gz'
  homepage 'http://tsung.erlang-projects.org/'
  sha1 'eae825076eca5e5a7bd45d6d107d2a2076736c03'

  depends_on 'erlang'
  depends_on 'gnuplot'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
