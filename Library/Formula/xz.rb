require 'formula'

# Upstream project has requested we use a mirror as the main URL
# https://github.com/mxcl/homebrew/pull/21419
class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://fossies.org/linux/misc/xz-5.0.5.tar.gz'
  mirror 'http://tukaani.org/xz/xz-5.0.5.tar.gz'
  sha256 '5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a'

  bottle do
    cellar :any
    revision 1
    sha1 '38f4e91b7f0ab45aa542de3a558c3077a928f7c5' => :mavericks
    sha1 'eed9e2dde1cea8dda3915ac0350fdf3fa3753640' => :mountain_lion
    sha1 '809720f5602d11f0e4507f43563d9061f4cd444e' => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
