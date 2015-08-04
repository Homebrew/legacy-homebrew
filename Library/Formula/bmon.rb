class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v3.6/bmon-3.6.tar.gz"
  sha256 "62c8c20d00572a7670891d4c112924786cb69ec4ca92d5052951566f000d1514"

  bottle do
    sha1 "a6288882c0c468f2d3d3c484c2f58c3ec2ec1856" => :yosemite
    sha1 "b1735717a26afeb7e5d06172ba7ed0f14d2e70a0" => :mavericks
    sha1 "70b7cb76fa2f1f3f53e0baaaf3b089276ca7a5db" => :mountain_lion
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "confuse" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make" # two steps to prevent blowing up
    system "make", "install"
  end

  test do
    system "#{bin}/bmon", "-o", "ascii:quitafter=1"
  end
end
