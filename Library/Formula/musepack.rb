class Musepack < Formula
  desc "Audio compression format and tools"
  homepage "https://www.musepack.net/"
  url "http://files.musepack.net/source/musepack_src_r475.tar.gz"
  version "r475"
  sha256 "a4b1742f997f83e1056142d556a8c20845ba764b70365ff9ccf2e3f81c427b2b"

  bottle do
    cellar :any
    sha256 "2e6bad894063f1178ff43b5cd10a899b82baa757228c3a51488793a4a22acdf2" => :yosemite
    sha256 "4ff9d23d8631300ff2619d9f1a7d99e07f8636c6e8d8db8dbf1335a21c1f7e27" => :mavericks
    sha256 "ac50f1100cdb2c91846a5d5a8d364cdb31abaeb7823ccbfc6614829f96540c6d" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libcuefile"
  depends_on "libreplaygain"

  resource "test-mpc" do
    url "https://trac.ffmpeg.org/raw-attachment/ticket/1160/decodererror.mpc"
    sha256 "b16d876b58810cdb7fc06e5f2f8839775efeffb9b753948a5a0f12691436a15c"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    lib.install "libmpcdec/libmpcdec.dylib"
  end

  test do
    resource("test-mpc").stage do
      assert_match(/441001 samples decoded in/,
                   shell_output("#{bin}/mpcdec decodererror.mpc 2>&1"))
    end
  end
end
