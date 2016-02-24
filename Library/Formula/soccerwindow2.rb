class Soccerwindow2 < Formula
  desc "Tools for RoboCup Soccer Simulator"
  homepage "https://osdn.jp/projects/rctools/"
  url "http://dl.osdn.jp/rctools/51942/soccerwindow2-5.1.0.tar.gz"
  sha256 "3505f662144d5c97628191c941e84af4d384770733b9ff93ab8b58c2d1b9c22b"

  bottle do
    sha256 "512a8b510d126918d3e9cf156013dac0e769396c965e936dea46c9eb0d923ed7" => :mavericks
    sha256 "fd8db0e005a931e65068ce15d1147a3bda413a2da67d8ba0e18332dee428052c" => :mountain_lion
    sha256 "6a6ab2f7a940081710deaf38049a99a392ea223439ee977d3470d975066290c3" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "boost"
  depends_on "librcsc"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/soccerwindow2 -v | grep 'soccerwindow2 Version #{version}'"
  end
end
