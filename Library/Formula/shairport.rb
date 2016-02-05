class Shairport < Formula
  desc "Airtunes emulator"
  homepage "https://github.com/abrasive/shairport"
  url "https://github.com/abrasive/shairport/archive/1.1.1.tar.gz"
  sha256 "1b60df6d40bab874c1220d7daecd68fcff3e47bda7c6d7f91db0a5b5c43c0c72"

  head "https://github.com/abrasive/shairport.git"

  bottle do
    cellar :any
    sha256 "802bbe38bc98c8fc8174eae3e41c6d00914d551626c051cb9dc7ba6af4edcf18" => :el_capitan
    sha256 "b3d9925e0335227f0ac5efc0f5d32d59cc41ea4af08a9db1658f68992e89f30f" => :yosemite
    sha256 "589f12f2a0b495dafc3536f04c3901aff75da0ec1e99ac8ec5e9916b629c17fd" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pulseaudio" => :optional
  depends_on "libao" => :optional
  depends_on "openssl"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/shairport", "-h"
  end
end
