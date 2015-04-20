require 'formula'

class Tsung < Formula
  homepage 'http://tsung.erlang-projects.org/'
  url 'http://tsung.erlang-projects.org/dist/tsung-1.5.1.tar.gz'
  sha1 'a997b76399dc40d3bda27d84c701c795ee40b808'

  head 'https://github.com/processone/tsung.git'

  depends_on 'erlang'
  depends_on 'gnuplot'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
