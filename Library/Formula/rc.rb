require 'formula'

class Rc < Formula
  homepage 'http://doc.cat-v.org/plan_9/4th_edition/papers/rc'
  url 'ftp://rc.quanstro.net/pub/rc-1.7.2.tgz'
  sha1 '9e51d99677244af1768ff8dd2cbac4ac162350c1'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-editline"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rc", "-c", "echo Hello!"
  end
end
