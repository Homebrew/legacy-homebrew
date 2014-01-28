require 'formula'

# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://fossies.org/linux/misc/xz-5.0.5.tar.gz'
  mirror 'http://tukaani.org/xz/xz-5.0.5.tar.gz'
  sha256 '5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a'

  bottle do
    cellar :any
    revision 2
    sha1 'ed851938129e0173354a4e0a7058037dac8e0104' => :mavericks
    sha1 'e73944a34e81f7e4f097c24203bd935a140965ca' => :mountain_lion
    sha1 'aff7ceb3547130722b9928a6f1e72c9d44b92a21' => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
