require 'formula'

class Libbow < Formula
  url 'https://github.com/jashmenn/libbow-osx/zipball/master'
  homepage 'http://www.cs.cmu.edu/~mccallum/bow/'
  md5 '5d3906b49752fa3080ddb659062c6576'
  version "20020213"

  def install
    ENV.append 'CFLAGS', "-fnested-functions"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "rainbow --help"
  end
end
