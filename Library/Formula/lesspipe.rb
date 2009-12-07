require 'formula'

class Lesspipe < Formula
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'ftp://ftp.ifh.de/pub/unix/utility/lesspipe-1.70.tar.gz'
  md5 '1eefbc1a4d95bb0726fc23ff5c66fc2e'

  def install
    system "./configure", "--prefix=#{prefix}", "--default"
    man1.mkpath
    system "make install"
  end
end
