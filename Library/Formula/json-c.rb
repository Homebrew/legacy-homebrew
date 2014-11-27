require "formula"

class JsonC < Formula
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.11-20130402.tar.gz"
  version "0.11"
  sha1 "1910e10ea57a743ec576688700df4a0cabbe64ba"

  bottle do
    cellar :any
    revision 2
    sha1 "9066fa256094d7836546e0a9a89f540010b48896" => :yosemite
    sha1 "3d4aff56dc15feecc79cda2f3cf30e0eb54e9489" => :mavericks
    sha1 "26b39365b735048ca6c42b340ececdc146666e79" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make install"
  end
end
