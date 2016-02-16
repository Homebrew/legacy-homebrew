class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.3.11.tar.gz"
  sha256 "77b87af4b2976ef7c6b0c79e071284c2c1b035a9543273ec925f9d92f73b8763"

  bottle do
    cellar :any
    sha256 "f2bab013d43e716f85a72afc331ad82fe7b3020172bbe50472d1426b0ccbd690" => :el_capitan
    sha256 "1fcdf66c7022f413f353d6ba8c75c1b06855b93382fcf90501209b0ca6801800" => :yosemite
    sha256 "27137dda9520c0d7418ca3cb63f054e7ae486a86ba85bc9c60024257ea92f014" => :mavericks
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
