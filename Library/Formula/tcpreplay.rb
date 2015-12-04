class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.1.0/tcpreplay-4.1.0.tar.gz"
  sha256 "ad285b08d7a61ed88799713c4c5d657a7a503eee832304d3a767f67efe5d1a20"

  bottle do
    cellar :any
    revision 1
    sha256 "03bfe9130780358c6a9d37e8b663f84c0e939b03c5efa87c90985584d95d2cbc" => :el_capitan
    sha256 "26ae99b72e3dc9feb27db71dd1f49de8734aff9debc1ed279c5a359fa5d4fece" => :yosemite
    sha256 "ab0379428462fbdc2653feae2bcc404cf6b6d2129ddf0461019c53794ce87e4f" => :mavericks
  end

  depends_on "libdnet" => :recommended

  def install
    # Recognise .tbd files inside Xcode 7 as valid.
    # https://github.com/appneta/tcpreplay/pull/202
    # Merged but into configure.ac, so inreplace here to avoid needing autotools.
    inreplace "configure", "for ext in .dylib .so", "for ext in .dylib .so .tbd"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link",
                          "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpreplay", "--version"
  end
end
