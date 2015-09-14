class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "http://lensfun.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.1/lensfun-0.3.1.tar.gz"
  sha256 "216c23754212e051c8b834437e46af3812533bd770c09714e8c06c9d91cdb535"
  head "http://git.code.sf.net/p/lensfun/code"
  revision 1

  bottle do
    sha256 "d267b6318b37f43153033958ed487732b14ef0362576673334baa9d0bce596b2" => :yosemite
    sha256 "f5e5e2e1af79de22e5b08ef98e8d66335de6b30e4a6d0391d1ae00ccf8ee3868" => :mavericks
    sha256 "c50bcbf69c3839a44d0bb988ea016dcabb259be866ae10dd9b3a04d3de87a487" => :mountain_lion
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
