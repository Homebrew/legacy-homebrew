require 'formula'

class Zssh < Formula
  url 'http://sourceforge.net/projects/zssh/files/zssh/1.5/zssh-1.5c.tgz'
  homepage 'http://zssh.sourceforge.net/'
  md5 '9f140ec2705a96d6a936b7dca0e8dd13'

  depends_on 'lrzsz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "zssh"
    bin.install "ztelnet"
    man1.install "zssh.1"
    man1.install "ztelnet.1"
  end
end
