require "formula"

class Arping < Formula
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.14.tar.gz"
  sha1 "f691b19e1ad20b853202ee12eaf178232b466bb2"

  bottle do
    cellar :any
    sha1 "bea3fb0806849cf6d60c858b8618a62fd1f84d7d" => :mavericks
    sha1 "ff1e5818b770a36bf45f1ed1eb2b9650f55585b6" => :mountain_lion
    sha1 "6f84c046e41c2727f7326059aeab928c44cc7d18" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
