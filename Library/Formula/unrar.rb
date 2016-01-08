class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.3.9.tar.gz"
  sha256 "ff593728aed0ac865908b8ea52cff449a4c298f095db2f3d27438ffbc3e35d5b"

  bottle do
    cellar :any
    sha256 "b5b5faa7d9226fa369bf29dcff229a304d0e7daba1372d84f03258d2b1826f23" => :el_capitan
    sha256 "aec95cf84c0ec8855bfa84b6b109ae32dc7e1fc5024dda7c7db1100ca15191f1" => :yosemite
    sha256 "d6af4e5a540a37fc3e2a220640c1472c9f66d80294afc989ec63f54b7d698bfe" => :mavericks
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
