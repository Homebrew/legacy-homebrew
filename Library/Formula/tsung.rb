require 'formula'

class Tsung < Formula
  url 'http://tsung.erlang-projects.org/dist/tsung-1.3.3.tar.gz'
  homepage 'http://tsung.erlang-projects.org/'
  md5 'c517187b44e22c5b3e169f4dff3164ca'

  depends_on 'erlang'
  depends_on 'gnuplot'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
