require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/tarball/7.3'
  md5 '29a4a350f4c6986df628f4210f2cbb37'

  head 'https://github.com/buganini/bsdconv.git'

  def install
    ENV.j1 # Library must be built before the codec tables are generated
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/bsdconv"
  end
end
