require 'formula'

class Check < Formula
  homepage 'http://check.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/check/check/0.9.9/check-0.9.9.tar.gz'
  sha1 '96c06ff9971884628c2512f0e3bca6141c49290b'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    # include fixes from head to work around no POSIX realtime extensions support on Mac OS
    "https://gist.github.com/kevinbirch/96f37737fcb5f4abbb87/raw/f20cb92ac6442e12c95c93e3aafe958681f1a006/fix-check-r0.9.9-build-errors-on-mac-os.diff"
  end
end
