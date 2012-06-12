require 'formula'

class Sshfs < Formula
  homepage 'http://fuse.sourceforge.net/sshfs.html'
  url 'https://github.com/fuse4x/sshfs/tarball/sshfs_2_4_0'
  md5 'c9ea547b9684ec4d85437393a2731322'
  version '2.4.0'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'
  depends_on 'glib'

  if MacOS.xcode_version >= "4.3"
    # remove the autoreconf if possible, no comment provided about why it is there
    # so we have no basis to make a decision at this point.
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info fuse4x-kext`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
