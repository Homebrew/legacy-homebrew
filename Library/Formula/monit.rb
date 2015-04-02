require "formula"

class Monit < Formula
  homepage "http://mmonit.com/monit/"
  url "http://mmonit.com/monit/dist/monit-5.12.tar.gz"
  sha1 "0eccc5a2b39a165e23902541f65608001582fb0e"

  bottle do
    cellar :any
    sha1 "c21b130f1492f1ec2d64aaf2af28e2f7924bd3c7" => :yosemite
    sha1 "a0a3f64fe0ef95bc2adb2e5a3a0cf5647a6d3ef5" => :mavericks
    sha1 "1f6659744cdcfc0324d74ee0237d61ca14d62b25" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end

  test do
    system "#{bin}/monit", "-h"
  end
end
