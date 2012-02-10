require 'formula'

class Tsung < Formula
  homepage 'http://tsung.erlang-projects.org/'
  url 'http://tsung.erlang-projects.org/dist/tsung-1.4.2.tar.gz'
  sha1 '1bd8c5676f8e3613333db4395f76df40975e2f2d'

  depends_on 'erlang'
  depends_on 'gnuplot'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
