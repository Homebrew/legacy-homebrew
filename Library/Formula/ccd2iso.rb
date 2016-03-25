class Ccd2iso < Formula
  desc "Convert CloneCD images to ISO images"
  homepage "http://ccd2iso.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccd2iso/ccd2iso/ccd2iso-0.3/ccd2iso-0.3.tar.gz"
  sha256 "f874b8fe26112db2cdb016d54a9f69cf286387fbd0c8a55882225f78e20700fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "e74b2779ef3d832bc899422285c2d03ea33aa6ab979ca835914343999b444671" => :el_capitan
    sha256 "020f198fa4476dc640fa14e8efa7ad04985143e7007c45610b890bdc7db47599" => :yosemite
    sha256 "46facd34e7bbf203fe76dcd6e99bcf066eb245992aef01f1d703a9ce7a69cac3" => :mavericks
    sha256 "a1b425ff8a3eca4faa223119b1c5b4bd4cfc4be5a1f8bf953e3776cca4426155" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(
      /^#{Regexp.escape(version)}$/, shell_output("#{bin}/ccd2iso --version")
    )
  end
end
