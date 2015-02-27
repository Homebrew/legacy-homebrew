# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  homepage "http://tukaani.org/xz/"
  url "https://fossies.org/linux/misc/xz-5.2.1.tar.gz"
  mirror "http://tukaani.org/xz/xz-5.2.1.tar.gz"
  sha256 "b918b6648076e74f8d7ae19db5ee663df800049e187259faf5eb997a7b974681"

  bottle do
    cellar :any
    sha1 "3ff6acf698890f64dd8c78e447f5f2e329d2d77a" => :yosemite
    sha1 "b4d71a6a28aaf4e0f85d54d6f5221e9548130b60" => :mavericks
    sha1 "80f2f7c33a227f57daa63fe5beb8e1f90c8ce6e9" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
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
