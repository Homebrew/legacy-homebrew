class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "http://www.musicpd.org/libs/libmpdclient/"
  url "http://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.10.tar.gz"
  sha256 "bf88ddd9beceadef11144811adaabe45008005af02373595daa03446e6b1bf3d"

  bottle do
    cellar :any
    sha256 "260ae000202c5d848b014c682db6f414b621c37fa0ada15a50d39ffa30a7d06e" => :el_capitan
    sha1 "9be910acd8278521e8f43b20448f31d7bb841ca5" => :yosemite
    sha1 "a5e180c855e756a33049a7f5aa4b2b4776cb6967" => :mavericks
    sha1 "e7e1ea43d44615bdacb1d4bb06ad8e4413e30ac2" => :mountain_lion
  end

  head do
    url "git://git.musicpd.org/master/libmpdclient.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build

  option :universal

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh" if build.head?

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
