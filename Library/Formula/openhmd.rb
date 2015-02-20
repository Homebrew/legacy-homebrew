class Openhmd < Formula
  homepage "http://openhmd.net"

  url "http://openhmd.net/releases/openhmd-0.1.0.tar.gz"
  sha1 "186c747399bd9a509ac8300acbae8823fc4fcc79"

  head "https://github.com/OpenHMD/OpenHMD.git", :branch => "master"

  head do
    sha1 "bd475d6a2992d0729e3c376a013ff97f3bbce387"
  end

  depends_on "cmake" => :build
  depends_on "autoconf" => :build # if built from git
  depends_on "automake" => :build # if built from git
  depends_on "pkg-config" => :build # not sure yet
  depends_on "hidapi"
  depends_on "libtool" => :build if build.head?

  def install

    if not build.head?
      opoo "run `brew install openhmd --HEAD' (from git HEAD) for DK2 support (02/2015)"
    end

    args = ["--prefix", prefix,
            "--disable-debug",
            "--disable-silent-rules",
            "--disable-dependency-tracking"]

    system "./autogen.sh" if build.head? # (if building openhmd from the git repository)

    system "./configure", *args

    system "make", "install"
  end

  test do
    system "false"
  end
end
