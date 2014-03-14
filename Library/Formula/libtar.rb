require 'formula'

class Libtar < Formula
  homepage 'http://repo.or.cz/w/libtar.git'
  url 'http://repo.or.cz/w/libtar.git/snapshot/v1.2.20.tar.gz'
  sha1 '3432cc24936d23f14f1e74ac1f77a1b2ad36dffa'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
