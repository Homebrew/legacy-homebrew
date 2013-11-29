require 'formula'

class Bup < Formula
  homepage 'https://github.com/bup/bup'
  head 'https://github.com/bup/bup.git', :branch => 'master'
  url 'https://github.com/bup/bup/archive/0.25-rc4.tar.gz'
  version '0.25-rc4'
  sha1 '12f382dcb7e1d3b8496dfc32d2395e80cf5d971e'

  option "run-tests", "Run unit tests after compilation"

  depends_on :python

  def install
    python do
      system "make"
    end
    system "make test" if build.include? "run-tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
