require "formula"

# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  homepage "http://tukaani.org/xz/"
  url "http://fossies.org/linux/misc/xz-5.0.7.tar.bz2"
  mirror "http://tukaani.org/xz/xz-5.0.7.tar.bz2"
  sha256 "e8851dc749df2340dac6c9297cb2653eff684e73c3dedf690930119502edd616"

  bottle do
    cellar :any
    sha1 "9e340d49dcfd08d82b59211ec7778b384bfa59f8" => :yosemite
    sha1 "c54becb676547560824fb873d6a04f24aa3e27aa" => :mavericks
    sha1 "d3ee779d021906abde55b3672135a0cac27c73b0" => :mountain_lion
    sha1 "99d721024996c74abf542373a03d85e121a0714a" => :lion
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
