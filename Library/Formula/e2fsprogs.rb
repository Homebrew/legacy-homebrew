class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "http://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.42.13/e2fsprogs-1.42.13.tar.gz"
  mirror "https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.13/e2fsprogs-1.42.13.tar.gz"
  sha256 "59993ff3a44f82e504561e0ebf95e8c8fa9f9f5746eb6a7182239605d2a4e2d4"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "5c3c8238210a6046c8999092cc7f490e0d4a91e98ff6f90ca7d2c5923728389a" => :el_capitan
    sha256 "ccba1fffeaa3fad12b434ee7a7ab54a5fc191287c2bcb5b66905a435eda10d17" => :yosemite
    sha256 "3f95be44af372f34e747aa4b7a89a721a170cc0cafee21b5ae4b85c630d2972f" => :mavericks
  end

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper"
    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
