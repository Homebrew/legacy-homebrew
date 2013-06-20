require 'formula'

class Ccze < Formula
  homepage 'http://packages.debian.org/wheezy/ccze'
  url 'http://ftp.de.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz'
  sha1 'a265e826be8018cd2f1b13ea1e96e27cc1941d02'
  
  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-builtins=all"
    system "make", "install"
  end

  test do
    system "#{bin}/ccze", "--help"
  end
end
