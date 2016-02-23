class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.3.11.tar.gz"
  sha256 "77b87af4b2976ef7c6b0c79e071284c2c1b035a9543273ec925f9d92f73b8763"

  bottle do
    cellar :any
    sha256 "ce96926101ae91bf66d3a8959f23a28c43099156050ff9be7a1e146d63b31cad" => :el_capitan
    sha256 "c10d8079a861166c1c4367d55ed931772c80db9056ecd6a3c4a906cf8f0415b9" => :yosemite
    sha256 "742c387769b8ba83563bb2bc67795d3bb26809ee39e08419fbaf5f28fb737ece" => :mavericks
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
