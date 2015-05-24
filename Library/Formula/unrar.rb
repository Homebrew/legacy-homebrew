class Unrar < Formula
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.2.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/non-free/u/unrar-nonfree/unrar-nonfree_5.2.7.orig.tar.gz"
  sha256 "ef14757e943787b439fedf2c564c1f38d0db315528a928e0de170860717e2fac"

  bottle do
    cellar :any
    sha1 "35ddc5d74bfd56378d022d0e13fa0d84eda20940" => :yosemite
    sha1 "05432384ebe9ec1fde99a2c3ecf3c9e31625046e" => :mavericks
    sha1 "ab5d36a8c64cd3d7ad40d7a7a13c761f3d84ec65" => :mountain_lion
  end

  def install
    system "make"
    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"

    bin.install "unrar"
    # Sent an email to dev@rarlab.com (18-Feb-2015) asking them to look into
    # the need for the explicit clean, and to change the make to generate a
    # dylib file on OS X
    lib.install "libunrar.so" => "libunrar.dylib"
  end

  test do
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data =  "UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE" \
            "QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA="

    rarpath.write data.unpack("m").first
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $?.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
