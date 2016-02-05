class Openhmd < Formula
  desc "Free and open source API and drivers for immersive technology"
  homepage "http://openhmd.net"
  url "http://openhmd.net/releases/openhmd-0.1.0.tar.gz"
  sha256 "14e54b4cd33d7cd961a2c9724efb77a5504fd4dc6091d488e7737a0e2f2df51d"

  bottle do
    cellar :any
    revision 1
    sha256 "50917839a2a060a9a350dad6117bc3bc946a37c129774a4c8e2be89aa9ecec16" => :el_capitan
    sha256 "7d50acf26200c9ef86554a79ec610d745ce6c5b4188cd882b00222ec3faa5fea" => :yosemite
    sha256 "d3b4293c6c9f9979cf36e259da2775065c8732107f54f12a7bf55d08d9a2ac79" => :mavericks
  end

  head do
    url "https://github.com/OpenHMD/OpenHMD.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "cspice", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hidapi"

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
