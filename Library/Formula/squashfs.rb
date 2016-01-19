class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "http://squashfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"

  bottle do
    cellar :any
    sha256 "b5380ee1f0cc0e75247595d88776969320356d101e10904e05790a49c8cb8cf4" => :mavericks
    sha256 "cff4a52a46551c1ba0e36665e621d85ae8bf70b0179573e9988d51ec7acf3527" => :mountain_lion
    sha256 "653847541022af3fc973719d73d5f0f1e030a5f6c5a9e0e76244026aa8cc7007" => :lion
  end

  depends_on "lzo"
  depends_on "xz"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures
  # Also clang fixes, extra endianness knowledge and a bundle of other OS X fixes.
  # Originally from https://github.com/plougher/squashfs-tools/pull/3
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Squashfs/squashfs.diff"
    sha256 "276763d01ec675793ddb0ae293fbe82cbf96235ade0258d767b6a225a84bc75f"
  end

  def install
    cd "squashfs-tools" do
      system "make XATTR_SUPPORT=0 EXTRA_CFLAGS=-std=gnu89 LZO_SUPPORT=1 LZO_DIR='#{HOMEBREW_PREFIX}' XZ_SUPPORT=1 XZ_DIR='#{HOMEBREW_PREFIX}' LZMA_XZ_SUPPORT=1"
      bin.install %w[mksquashfs unsquashfs]
    end
    doc.install %w[ACKNOWLEDGEMENTS CHANGES COPYING INSTALL OLD-READMEs PERFORMANCE.README README README-4.3]
  end
end
