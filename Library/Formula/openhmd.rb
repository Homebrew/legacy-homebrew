class Openhmd < Formula
  homepage "http://openhmd.net"
  url "http://openhmd.net/releases/openhmd-0.1.0.tar.gz"
  sha1 "186c747399bd9a509ac8300acbae8823fc4fcc79"

  head do
    url "https://github.com/OpenHMD/OpenHMD.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hidapi" => :build

  def install
    args = ["--prefix", prefix,
            "--disable-debug",
            "--disable-silent-rules",
            "--disable-dependency-tracking",
            "--bindir=#{bin}"]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    (share+"tests").install "#{bin}/unittests"
  end

  test do
    system "#{share}/tests/unittests"
  end
end
