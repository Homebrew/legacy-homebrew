class Libpuzzle < Formula
  desc "Library to find visually similar images"
  homepage "https://www.pureftpd.org/project/libpuzzle"
  url "https://download.pureftpd.org/pub/pure-ftpd/misc/libpuzzle/releases/libpuzzle-0.11.tar.bz2"
  sha256 "ba628268df6956366cbd44ae48c3f1bab41e70b4737041a1f33dac9832c44781"

  bottle do
    cellar :any
    revision 2
    sha256 "0768fc24347a5e5e061722175cae535b6e295c28302d98ad3e03dc9f79a32bf0" => :el_capitan
    sha256 "d8f7de77378d0fa29e34876ccc8def7f8e60e6564a1c17dae77f4c32ebd8ae5a" => :yosemite
    sha256 "ed3d860aa40203a73921fc7f6919828599a28fb39e2d95f0c963ae4eb5c7811b" => :mavericks
  end

  depends_on "gd"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_equal "0",
      shell_output("#{bin}/puzzle-diff #{test_image} #{test_image}").chomp
  end
end
