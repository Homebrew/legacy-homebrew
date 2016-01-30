class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.7.0.tar.gz"
  sha256 "365ccb0c0779717b04111ea86962d24a4841c07289426003f24782295fbe4658"
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "e89e4a85294dfcb8c82be1ead9c76a05deee6a225de7dc2f51d640c38749eea4" => :el_capitan
    sha256 "7943af9ab8b85d06f8ed191835b74ba3d255f09382915c91e3a24e5b79880309" => :yosemite
    sha256 "7e6ee2e6e99136ce7c72588df855a440610e90e0e2737dfd22967cafc3713b4b" => :mavericks
  end

  option "without-docs", "Build without HTML docs"

  depends_on "cmake" => :build
  depends_on "libffi"
  depends_on "bdw-gc"

  def install
    arch = MacOS.prefer_64_bit? ? "x86_64" : "x86"

    args = std_cmake_args

    args += %W[
      -DCMAKE_SYSTEM_NAME=darwin
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].lib}
      -DCMAKE_SYSTEM_PROCESSOR=#{arch}
    ]

    system "cmake", *args
    system "make", "doc" if build.with? "docs"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
