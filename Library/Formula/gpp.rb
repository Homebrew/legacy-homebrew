class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "http://en.nothingisreal.com/wiki/GPP"
  url "http://files.nothingisreal.com/software/gpp/gpp-2.24.tar.bz2"
  sha256 "9bc2db874ab315ddd1c03daba6687f5046c70fb2207abdcbd55d0e9ad7d0f6bc"

  bottle do
    cellar :any
    revision 1
    sha1 "481357229fc529fbc72fd129e5fce856db2920c1" => :yosemite
    sha1 "61bc9c993cdb79a20b81351e77c6d0b92827910e" => :mavericks
    sha1 "6cce4a597e3c424471172be048a556e03a1afafc" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
