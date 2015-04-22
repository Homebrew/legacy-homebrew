class E2fsprogs < Formula
  homepage "http://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.42.12/e2fsprogs-1.42.12.tar.gz"
  mirror "https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.12/e2fsprogs-1.42.12.tar.gz"
  sha256 "e17846d91a0edd89fa59b064bde8f8e5cec5851e35f587bcccb4014dbd63186c"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

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
