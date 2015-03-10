class Zint < Formula
  homepage "https://zint.github.io/"
  url "https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz"
  sha256 "de2f4fd0d008530511f5dea2cff7f96f45df4c029b57431b2411b7e1f3a523e8"
  revision 1

  head "git://zint.git.sourceforge.net/gitroot/zint/zint"

  option "with-qt", "Build the zint-qt GUI"
  deprecated_option "qt" => "with-qt"

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "qt" => :optional

  def install
    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
