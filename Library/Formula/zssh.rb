require 'formula'

class Zssh < Formula
  url 'http://sourceforge.net/projects/zssh/files/zssh/1.5/zssh-1.5c.tgz'
  homepage 'http://zssh.sourceforge.net/'
  sha1 '68dc9b8572646ef63909b3855e7990d75f49926c'

  depends_on 'lrzsz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "zssh", "ztelnet"
    man1.install "zssh.1", "ztelnet.1"
  end
end
