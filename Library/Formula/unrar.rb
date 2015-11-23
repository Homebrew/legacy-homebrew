class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.2.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/non-free/u/unrar-nonfree/unrar-nonfree_5.2.7.orig.tar.gz"
  sha256 "ef14757e943787b439fedf2c564c1f38d0db315528a928e0de170860717e2fac"

  bottle do
    cellar :any
    sha256 "e64f77eb7e612172703a4773dec7de3bec7712d48b1d7380aa1ede98490ff80c" => :el_capitan
    sha256 "ffdc5094556410978817f2dbfded4549f777f900a4272c751e353af05785ee7a" => :yosemite
    sha256 "24e2ad74e328286726c3a89d5434373a3e3774d4b6e11df66a0e55ec43477642" => :mavericks
    sha256 "0490cda2a8226db2513a4e98bf1fa975d707b37fae09b8069c6b335bcb84d365" => :mountain_lion
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
