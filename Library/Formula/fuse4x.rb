require 'formula'

class Fuse4x < Formula
  homepage 'http://fuse4x.github.com'
  url 'https://github.com/fuse4x/fuse/tarball/fuse4x_0_9_1'
  version '0.9.1'
  sha1 '31eff485411f106daa81ef6c7c3d31abbdcd41b4'
<<<<<<< HEAD

  # Always use newer versions of these tools
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

<<<<<<< HEAD
  depends_on :automake
  depends_on :libtool
=======
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======

  # Always use newer versions of these tools
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  depends_on 'gettext'
  depends_on 'fuse4x-kext'

  def install
    # Build universal if the hardware can handle it---otherwise 32 bit only
    MacOS.prefer_64_bit? ? ENV.universal_binary : ENV.m32

    system "autoreconf", "--force", "--install"

    # force 64bit inodes on 10.5. On 10.6+ this is no-op.
    ENV.append_to_cflags "-D_DARWIN_USE_64_BIT_INODE"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
