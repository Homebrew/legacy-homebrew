require 'formula'

class Tsung < Formula
  homepage 'http://tsung.erlang-projects.org/'
  url 'http://tsung.erlang-projects.org/dist/tsung-1.5.0.tar.gz'
  sha1 '29cc209045ae7bc4aea1c9ab8269758135dbde27'

  depends_on 'erlang'
  depends_on 'gnuplot'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
