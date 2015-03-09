class Wcm < Formula
  homepage "http://wcm.linderdaum.com"
  url "https://github.com/corporateshark/WalCommander/archive/release-0.19.0.1.tar.gz"
  sha256 "af2b0779e7ffa51fad0c3901a8bd256546bc1bb7f4f156087f9706b066f8a871"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libssh2"
  depends_on :x11
  depends_on :macos => :mountain_lion

  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "all", "-j#{ENV.make_jobs}", "-B"
    system "make", "install"
  end

  test do
    system "#{bin}/wcm", "--help"
  end
end
