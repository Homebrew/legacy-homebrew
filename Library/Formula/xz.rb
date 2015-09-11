# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "http://tukaani.org/xz/"
  url "https://fossies.org/linux/misc/xz-5.2.1.tar.gz"
  mirror "http://tukaani.org/xz/xz-5.2.1.tar.gz"
  sha256 "b918b6648076e74f8d7ae19db5ee663df800049e187259faf5eb997a7b974681"

  bottle do
    cellar :any
    sha256 "28263dd18c32d552fe7ff87a78f33c70608c4cfaa6f39dfc5d718a1c1ef3cc88" => :el_capitan
    sha1 "fedcee4af6aae52f4ee471fad0071aefa442887b" => :yosemite
    sha1 "42f6a1501db4f6a298ba037bbd50ebfb7aa79d39" => :mavericks
    sha1 "8f9bb2675c7e967e2adc1679cb7190f697689075" => :mountain_lion
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
