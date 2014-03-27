require 'formula'

class Primesieve < Formula
  homepage 'http://primesieve.org/'
  url 'http://dl.bintray.com/kimwalisch/primesieve/primesieve-5.0.tar.gz'
  sha1 '2ffdf45dfd243f456cf6f07f9660fc92eebf9603'

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system 'make install'
  end

  test do
    system "#{bin}/primesieve", '2', '1000', '--count=1', '-p2'
  end
end
