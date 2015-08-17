class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "http://lensfun.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.1/lensfun-0.3.1.tar.gz"
  sha256 "216c23754212e051c8b834437e46af3812533bd770c09714e8c06c9d91cdb535"
  head "http://git.code.sf.net/p/lensfun/code"

  bottle do
    sha256 "a5b1e00b997a38d1ae19985b301e5eca97c084ca23f83ced3c25c6f3167568e8" => :yosemite
    sha256 "4ac0a93f45140195c8d73d3f886c021ed1bf022a602a39d29f10e7b96ae5e6ae" => :mavericks
    sha256 "7ab064b444b3bf7e8c08d0b57c32b1d71565ec644b9652657aab5a9d79542633" => :mountain_lion
  end

  depends_on :python3
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "doxygen" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
