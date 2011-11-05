require 'formula'

class Knock < Formula
  url 'http://www.zeroflux.org/proj/knock/files/knock-0.5.tar.gz'
  homepage 'http://www.zeroflux.org/projects/knock'
  md5 'ca09d61458974cff90a700aba6120891'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make knock man"
    bin.install "knock"
    man1.install Dir["doc/*.1"]
  end
end
