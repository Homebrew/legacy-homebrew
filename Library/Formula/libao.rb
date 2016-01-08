class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz"
  sha256 "03ad231ad1f9d64b52474392d63c31197b0bc7bd416e58b1c10a329a5ed89caf"

  bottle do
    revision 1
    sha256 "159aa7704f0a3cd36bfdf659ca8ec9c399077274bff1b68aa0497fdda8b6da44" => :el_capitan
    sha256 "08d568c4bed498b2920983d9b848213779164c15489c82cc61429533337d19f5" => :yosemite
    sha256 "81b1d6c5d1920092fba0470db2840414eb99bba8ec63d6d22800e79090db8e4b" => :mavericks
    sha256 "21aa15e92c5577a4a610de8fbb3f5a72638a0c37a40c4ebebc14826359932efa" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end
end
