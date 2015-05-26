require "formula"

class Libtermkey < Formula
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.17.tar.gz"
  sha1 "2f9f0724cabd81f0ae3ba7b2837ee15dd40130f9"

  bottle do
    cellar :any
    revision 1
    sha1 "0335d158aa03bd7ad2d75b9b902f8ae4ffc2c864" => :yosemite
    sha1 "29ba1ee30a2462b3eff036c2cdd32fbdcf349571" => :mavericks
    sha1 "c77ce1bf195352319b3f09da116a67922d4b4265" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
