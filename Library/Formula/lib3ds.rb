class Lib3ds < Formula
  desc "Library for managing 3D-Studio Release 3 and 4 '.3DS' files"
  homepage "https://code.google.com/p/lib3ds/"
  url "https://lib3ds.googlecode.com/files/lib3ds-1.3.0.zip"
  sha1 "544262eac73c1e4a1d77f0f1cbd90b990a996db8"

  bottle do
    cellar :any
    revision 1
    sha1 "73e8d8c384e541a8f00b0a9e5512c8d51e2140ab" => :yosemite
    sha1 "cfeeba0b43b699344e74faf55536c008c97791cc" => :mavericks
    sha1 "40bea2c7a1bad1d1516e04cd3bdb88b967270b7d" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # create a raw emtpy 3ds file.
    (testpath/"test.3ds").write("\x4d\x4d\x06\x00\x00\x00")
    system "#{bin}/3dsdump", "test.3ds"
  end
end
