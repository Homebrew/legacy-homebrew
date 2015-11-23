class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "http://squashfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"

  bottle do
    cellar :any
    sha1 "ea27e099828f9809190115e4eb874894d5234c9f" => :mavericks
    sha1 "3947dd7376c576b743ec2c9508d2ec9f2f8dcde5" => :mountain_lion
    sha1 "36eff8c566e09e78d5faae4558256317178f637d" => :lion
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
