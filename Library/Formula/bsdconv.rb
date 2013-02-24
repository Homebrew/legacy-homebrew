require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/tarball/9.0'
  sha1 '5b82f097575c9bbb0a1b809846c23f582da72bef'

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
