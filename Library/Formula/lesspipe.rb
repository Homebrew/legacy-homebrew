require 'formula'

class Lesspipe < Formula
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'http://www-zeuthen.desy.de/~friebel/unix/less/lesspipe-1.71.tar.gz'
  md5 '6d921dc4ce9809d405cb8d694ac7cbbd'

  def install
    system "./configure", "--prefix=#{prefix}", "--default"
    man1.mkpath
    system "make install"
  end
end
