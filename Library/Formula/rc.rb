class Rc < Formula
  homepage "http://doc.cat-v.org/plan_9/4th_edition/papers/rc"
  url "ftp://rc.quanstro.net/pub/rc-1.7.2.tgz"
  sha256 "89487c6c9f5ad0fdae658bf9564f6e920935bbdeabf63abdbf69b7c46f7ee40c"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-editline"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rc", "-c", "echo Hello!"
  end
end
