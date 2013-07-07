require 'formula'

class Ocrad < Formula
  homepage 'http://www.gnu.org/software/ocrad/'
  url 'http://ftpmirror.gnu.org/ocrad/ocrad-0.21.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ocrad/ocrad-0.21.tar.gz'
  sha1 '857a7e0b671d4216ddf2ec1ec2daf0b21d2a6a64'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end
end
