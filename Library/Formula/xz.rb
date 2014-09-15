require "formula"

# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  homepage "http://tukaani.org/xz/"
  url "http://fossies.org/linux/misc/xz-5.0.6.tar.gz"
  mirror "http://tukaani.org/xz/xz-5.0.6.tar.gz"
  sha256 "b6cf4cdc1313556a00848e722625bce40d2cd552c052b0465791c64c9202c3f1"

  bottle do
    cellar :any
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    assert !path.exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
