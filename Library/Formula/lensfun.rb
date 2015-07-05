class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "http://lensfun.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.1/lensfun-0.3.1.tar.gz"
  sha256 "216c23754212e051c8b834437e46af3812533bd770c09714e8c06c9d91cdb535"
  head "http://git.code.sf.net/p/lensfun/code"

  bottle do
    sha1 "3d14bc917c95bda7eb6f9e98f83c18b22fb048f1" => :yosemite
    sha1 "f75c7915e5701e605275e6d48a8c5c12ec981948" => :mavericks
    sha1 "b6b0966f02558cb8304a1206536a1d1e16afcb05" => :mountain_lion
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
