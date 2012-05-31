require 'formula'

class Ocrad < Formula
  homepage 'http://www.gnu.org/software/ocrad/'
  url 'http://ftpmirror.gnu.org/ocrad/ocrad-0.21.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ocrad/ocrad-0.21.tar.gz'
  md5 '83f9eae9d808f9d86c181538d3f64aed'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end
end
