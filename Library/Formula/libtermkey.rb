require "formula"

class Libtermkey < Formula
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.17.tar.gz"
  sha1 "2f9f0724cabd81f0ae3ba7b2837ee15dd40130f9"

  bottle do
    cellar :any
    sha1 "717abaaf66c19d08ec2d00e372e79717109d907f" => :mavericks
    sha1 "d41b7e58c29e7f32a010abac5424611281e00a4d" => :mountain_lion
    sha1 "ffe2d3ff9c51ea0cc959dcd8c5bde75130b85051" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
