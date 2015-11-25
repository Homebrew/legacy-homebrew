class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "http://en.nothingisreal.com/wiki/GPP"
  url "http://files.nothingisreal.com/software/gpp/gpp-2.24.tar.bz2"
  sha256 "9bc2db874ab315ddd1c03daba6687f5046c70fb2207abdcbd55d0e9ad7d0f6bc"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6925eb92be766ed9fe61a9a98dc7bc3c22793079abf63f462cb7001017cac28c" => :el_capitan
    sha256 "e9bb30f85bd24890f97160649a3ed9ef8081d0e39154226487b29e4c58d154ab" => :yosemite
    sha256 "90463e69adac31b694bbcac3e90ad494bb8e4ef4927d1a04e3a7246b87c0d55d" => :mavericks
    sha256 "bfcf6ef95b33a600dc6471b4f80e3dbb8e4f4e3cf13aa21b67990576ade35414" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
