require 'formula'

class Knock < Formula
  homepage 'http://www.zeroflux.org/projects/knock'
  url 'http://www.zeroflux.org/proj/knock/files/knock-0.6.tar.gz'
  sha1 '38bfee90ba3af780b3f8dc1179f0c52d47b60d2c'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make knock"
    bin.install "knock"
    man1.install "doc/knock.1"
  end
end
