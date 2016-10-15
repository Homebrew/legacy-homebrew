require "formula"

class Opendkim < Formula
  homepage "http://opendkim.org"
  url "http://downloads.sourceforge.net/project/opendkim/opendkim-2.9.0.tar.gz"
  sha1 "a51603ee73a2097efa045592dbde7825a85bd9dd"

  depends_on "unbound"

  def install
    system "./configure", "--disable-filter", # disable libmilter
                          "--with-unbound=#{HOMEBREW_PREFIX}/opt/unbound",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "test -e /usr/local/opt/opendkim/sbin/opendkim-genkey"
  end
end
