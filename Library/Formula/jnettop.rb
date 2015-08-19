class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "http://jnettop.kubs.info/"
  url "http://jnettop.kubs.info/dist/jnettop-0.13.0.tar.gz"
  sha256 "e987a1a9325595c8a0543ab61cf3b6d781b4faf72dd0e0e0c70b2cc2ceb5a5a0"

  bottle do
    cellar :any
    sha256 "871294088a51e4726a38b1fb3fc631d88176dbd7fbfd9e42adb2626f24c7499a" => :yosemite
    sha256 "5a4ddf114a63d47ca767875f565f1838f75975f26e803889aed580a40fcb95c4" => :mavericks
    sha256 "71e64877f2b989ec3eaffbe49e89c576cb14a42543bb37ad2218567f2200b3ff" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/jnettop", "-h"
  end
end
