require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/tarball/7.4'
  sha1 '897d2b59a76c1440fd60dcd305e9461828ac2deb'

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
