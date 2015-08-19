class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "http://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.42.12/e2fsprogs-1.42.12.tar.gz"
  mirror "https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.12/e2fsprogs-1.42.12.tar.gz"
  sha256 "e17846d91a0edd89fa59b064bde8f8e5cec5851e35f587bcccb4014dbd63186c"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "d2e1bcb92be39ebf971032b385fe5ffc6b0d69ec5df23fd0f4c5fb739f7f031e" => :yosemite
    sha256 "e77469345bab82888029836b5b221cfd07ac9a3e3dea79bb0893762312d31094" => :mavericks
    sha256 "fe5542c41eb4a541ef533d07a086fb3e6c9cdc51157ae9c32f62ac049842a74f" => :mountain_lion
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
