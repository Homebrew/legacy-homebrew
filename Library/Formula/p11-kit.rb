require 'formula'

class P11Kit < Formula
  homepage 'http://p11-glue.freedesktop.org'
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.12.tar.gz'
  sha256 '4db792def545a3c8ae12e7e4ef166d7620cb445c00a5a984ab7c4a3b35f0be00'

  # Upstream patch to fix failing test
  def patches
    "http://cgit.freedesktop.org/p11-glue/p11-kit/patch/?id=af8d28014f97ab0d9e4d00961e72aefd7adb470b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
