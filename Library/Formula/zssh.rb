require 'formula'

class Zssh < Formula
  homepage 'http://zssh.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/zssh/zssh/1.5/zssh-1.5c.tgz'
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
