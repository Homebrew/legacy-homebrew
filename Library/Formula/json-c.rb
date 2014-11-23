require "formula"

class JsonC < Formula
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.12-20140410.tar.gz"
  version "0.12"
  sha256 "99304a4a633f1ee281d6a521155a182824dd995139d5ed6ee5c93093c281092b"

  bottle do
    cellar :any
    sha1 "9066fa256094d7836546e0a9a89f540010b48896" => :yosemite
    sha1 "3d4aff56dc15feecc79cda2f3cf30e0eb54e9489" => :mavericks
    sha1 "26b39365b735048ca6c42b340ececdc146666e79" => :mountain_lion
  end

  head do
    url "https://github.com/json-c/json-c.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end
end
