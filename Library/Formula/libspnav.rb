class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "http://spacenav.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/spacenav/spacenav%20library%20%28SDK%29/libspnav%200.2.3/libspnav-0.2.3.tar.gz"
  sha256 "7ae4d7bb7f6a5dda28b487891e01accc856311440f582299760dace6ee5f1f93"

  bottle do
    cellar :any
    sha256 "87bf93469bb14eef1a24de81cd521f6a62363a6aa7c04a319f3f18905de039b1" => :yosemite
    sha256 "f425659deb611eacb94f2245f0c8f8235aa0169a422874f2aa2c32f8d207b84a" => :mavericks
    sha256 "0d0a4943d1eee96936b7ccf0a200d353a3fd35bbf67d46695e0e4e41d498df16" => :mountain_lion
  end

  option "with-x11", "Enable support for sending mouse events through the x11 protocol"

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--disable-x11" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <spnav.h>

      int main() {
        bool connected = spnav_open() != -1;
        if (connected) spnav_close();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lspnav", "-o", "test"
    system "./test"
  end
end
