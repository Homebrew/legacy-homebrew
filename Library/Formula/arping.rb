class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.15.tar.gz"
  sha256 "c6be96cff28cda27af89ecd60fc8466d2f8183208cd805a1aa40d8f190cdd2b6"

  bottle do
    cellar :any
    sha256 "73d6b99732d0d2f42b4099c45f491ae84bec0dfdc5071413631a428ed2e1ff81" => :el_capitan
    sha1 "26495a7b0026c0299e83117199910caffc85a5b0" => :yosemite
    sha1 "5214549465ff73bf0514b36249b9ceac4fba2903" => :mavericks
    sha1 "14d70651ab3cb56b74a397c590fb5080e82c48df" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
