class Fuse4x < Formula
  homepage "https://fuse4x.github.io"
  url "https://github.com/fuse4x/fuse/archive/fuse4x_0_9_2.tar.gz"
  sha256 "f51b2be4223fb811b30eab215d6bd7f5db50f8eba60e091d446fec4a3de382f7"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build
  depends_on ConflictsWithBinaryOsxfuse
  depends_on UnsignedKextRequirement
  depends_on "fuse4x-kext"

  conflicts_with "osxfuse", :because => "both install `fuse.pc`"

  def install
    # Build universal if the hardware can handle it---otherwise 32 bit only
    MacOS.prefer_64_bit? ? ENV.universal_binary : ENV.m32

    inreplace "makeconf.sh", "libtoolize", "glibtoolize"
    system "./makeconf.sh"

    # force 64bit inodes on 10.5. On 10.6+ this is no-op.
    ENV.append_to_cflags "-D_DARWIN_USE_64_BIT_INODE"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
