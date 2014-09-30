require "formula"

class Squashfs < Formula
  homepage "http://squashfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"

  depends_on "lzo"
  depends_on "xz"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures
  # Also clang fixes, extra endianness knowledge and a bundle of other OS X fixes.
  # Originally from https://github.com/plougher/squashfs-tools/pull/3
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Squashfs/squashfs.diff"
    sha1 "bf8aad479180a0614b74d4aa2fb5b8a0c1dc567b"
  end

  def install
    cd "squashfs-tools" do
      system "make XATTR_SUPPORT=0 EXTRA_CFLAGS=-std=gnu89 LZO_SUPPORT=1 LZO_DIR='#{HOMEBREW_PREFIX}' XZ_SUPPORT=1 XZ_DIR='#{HOMEBREW_PREFIX}' LZMA_XZ_SUPPORT=1"
      bin.install %w{mksquashfs unsquashfs}
    end
    doc.install %w{ACKNOWLEDGEMENTS CHANGES COPYING INSTALL OLD-READMEs PERFORMANCE.README README README-4.3}
  end
end
