require 'formula'

class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage 'http://tsung.erlang-projects.org/'
  url 'http://tsung.erlang-projects.org/dist/tsung-1.6.0.tar.gz'
  sha256 '56846c3a90fd7037d9a76330cb8f3052238344491e2fe6ef1ebdb0b620eb3d84'

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
