# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "http://tukaani.org/xz/"
  url "https://fossies.org/linux/misc/xz-5.2.2.tar.gz"
  mirror "http://tukaani.org/xz/xz-5.2.2.tar.gz"
  sha256 "73df4d5d34f0468bd57d09f2d8af363e95ed6cc3a4a86129d2f2c366259902a2"

  bottle do
    cellar :any
    sha256 "7cfefbef7669a6959eb019ffba2d06b2c8f041fb826e89126c1ced23f03e2029" => :el_capitan
    sha256 "cd13b4dea278b179eceebed9f07b79c95e7416d7cac0ba095173cc463149df46" => :yosemite
    sha256 "9a5b520ae6a4cc728a7f5c4a15deb1dc2f150e3665d5afbc802b07f2a4fbd6e6" => :mavericks
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
