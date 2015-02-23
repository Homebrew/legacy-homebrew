class Unrar < Formula
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.2.6.tar.gz"
  sha1 "bdd4c8936fd0deb460afe8b7afa9322dd63f3ecb"

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
