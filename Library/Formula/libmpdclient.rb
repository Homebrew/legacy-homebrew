class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "http://www.musicpd.org/libs/libmpdclient/"
  url "http://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.10.tar.gz"
  sha256 "bf88ddd9beceadef11144811adaabe45008005af02373595daa03446e6b1bf3d"

  bottle do
    cellar :any
    sha256 "260ae000202c5d848b014c682db6f414b621c37fa0ada15a50d39ffa30a7d06e" => :el_capitan
    sha256 "53c232fdc4c66fb2aa823b474337f8c5275cf01171077b8772a0dd2b1aaf670c" => :yosemite
    sha256 "a6d500dd34581bb30a623df20b2e031eb3f1a6a586886acc97e437a5447e144b" => :mavericks
    sha256 "d583dffa231db87e89bc291d20aedb63d9ac5324eeff80cdc974cff2b93c6a1a" => :mountain_lion
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
