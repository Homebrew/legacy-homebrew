class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.3.10.tar.gz"
  sha256 "db7992213a53e0aaea8e4e5f85b01908f3486a4da7b2eb24664c2ff213c8f895"

  bottle do
    cellar :any
    sha256 "748dbb261915df5589affb34106ebcff8ebce98de2af8c1cb3fe96508b223677" => :el_capitan
    sha256 "dc16b6b2559cd742496943630515e680015a528a2d778387645da3e199da9ef6" => :yosemite
    sha256 "f8a1e6b77b084149c499d06c3782cf7e1ee9f7c0b452ed6fedbdbb172ab8cc2c" => :mavericks
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
