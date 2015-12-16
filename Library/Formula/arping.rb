class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.15.tar.gz"
  sha256 "c6be96cff28cda27af89ecd60fc8466d2f8183208cd805a1aa40d8f190cdd2b6"

  bottle do
    cellar :any
    sha256 "73d6b99732d0d2f42b4099c45f491ae84bec0dfdc5071413631a428ed2e1ff81" => :el_capitan
    sha256 "318af3170cd53f825127c924c2db4a687cf1a941ed07e9a27f3e6f0cd47a5c18" => :yosemite
    sha256 "646667e7e2a3856907d100f9cda07ff778af5df4d090741e08ed132e339bffcf" => :mavericks
    sha256 "e7eb1c41175b3151754a0bd4a909946f97e2c2f00fa566343ebd944b1e1c79c1" => :mountain_lion
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
