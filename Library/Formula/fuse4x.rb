require 'formula'

class Fuse4x < Formula
  homepage 'http://fuse4x.github.com'
  url 'https://github.com/fuse4x/fuse/tarball/fuse4x_0_9_2'
  sha1 '316df7c0bb2caa6d32300b31fdeba3267ee6f41f'

  # Always use newer versions of these tools
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on 'gettext'
  depends_on 'fuse4x-kext'

  def install
    # Build universal if the hardware can handle it---otherwise 32 bit only
    MacOS.prefer_64_bit? ? ENV.universal_binary : ENV.m32

    inreplace 'configure.in', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    inreplace 'makeconf.sh', 'libtoolize', 'glibtoolize'
    system './makeconf.sh'

    # force 64bit inodes on 10.5. On 10.6+ this is no-op.
    ENV.append_to_cflags "-D_DARWIN_USE_64_BIT_INODE"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
