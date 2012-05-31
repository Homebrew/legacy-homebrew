require 'formula'

class Rc < Formula
  url 'ftp://rc.quanstro.net/pub/rc-1.7.2.tgz'
  homepage 'http://doc.cat-v.org/plan_9/4th_edition/papers/rc'
  md5 '4a85e4b4e3a0a5d3803109c5b2dce710'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-editline"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rc", "-c", "echo Hello!"
  end
end
