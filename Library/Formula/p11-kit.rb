require 'formula'

class P11Kit < Formula
  homepage 'http://p11-glue.freedesktop.org'
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.13.tar.gz'
  sha256 '3cb942465efd5bde1c1875826118fe4bca45b0c9edc7c87835909a5866bed325'

  def patches
    # Upstream patch to fix duplicate symbol error
    "http://cgit.freedesktop.org/p11-glue/p11-kit/patch/?id=4a6a685c03bd"
  end

  def install
    ENV.universal_binary
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
