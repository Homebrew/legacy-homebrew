class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.4.tar.gz"
  sha256 "dc7695513e715654a51d07ad3e6b0083f9cb38b1a5bc9f16e1177d15af992dcc"

  bottle do
    cellar :any
    sha256 "8ccc144f89e11b04454f9325435673ff71ea94fa338201de6eca7d061d338b23" => :yosemite
    sha256 "190c6d48b0e36513acb206e16e38499f67bfade858042f035c12db6455abc153" => :mavericks
    sha256 "c3e7f23a822474155414b30a6d45492e44aec10a80af2e9813414eaff190f3a9" => :mountain_lion
  end

  depends_on "libsodium"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "minisign", "-v"
  end
end
