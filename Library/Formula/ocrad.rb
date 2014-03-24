require 'formula'

class Ocrad < Formula
  homepage 'http://www.gnu.org/software/ocrad/'
  url 'http://ftpmirror.gnu.org/ocrad/ocrad-0.23.tar.lz'
  mirror 'http://ftp.gnu.org/gnu/ocrad/ocrad-0.23.tar.lz'
  sha1 '8f539613ce6eb816c691f37ef0977adfcdab5e92'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    system "#{bin}/ocrad", "-h"
  end
end
