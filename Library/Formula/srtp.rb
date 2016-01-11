class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.5.2.tar.gz"
  sha256 "86e1efe353397c0751f6bdd709794143bd1b76494412860f16ff2b6d9c304eda"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    revision 1
    sha256 "7a9ac7216782ef2ff6e351705a627eaf535c412fb668086868ab86e5a8334413" => :yosemite
    sha256 "28561181099811365178f954b2938c7921dfcd5cdbf2e5129dbf4ae3fb15b910" => :mavericks
    sha256 "bc26d7076d2cb0c219ab498e2760153ed22b6703be69a5120c114be9d8e5ee2a" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
  end
end
