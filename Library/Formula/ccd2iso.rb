class Ccd2iso < Formula
  desc "Convert CloneCD images to ISO images"
  homepage "http://ccd2iso.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccd2iso/ccd2iso/ccd2iso-0.3/ccd2iso-0.3.tar.gz"
  sha256 "f874b8fe26112db2cdb016d54a9f69cf286387fbd0c8a55882225f78e20700fc"

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
