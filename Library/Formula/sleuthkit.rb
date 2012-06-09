require 'formula'

class Sleuthkit < Formula
  head 'https://github.com/sleuthkit/sleuthkit.git'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.2.3/sleuthkit-3.2.3.tar.gz'
  homepage 'http://www.sleuthkit.org/'
  md5 '29465ebe32cfeb5f0cab83e4e93823c5'

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def patches
    # required for new-ish libewf releases (API change)
    # fixed in the upcoming sleuthkit 4.x
    "http://downloads.sourceforge.net/project/libewf/patches%20for%203rd%20party%20software/sleuthkit/tsk3.2.3-libewf.patch" if !ARGV.build_head?
  end

  def install
    if ARGV.build_head?
      system "glibtoolize"
      system "aclocal"
      system "automake", "--add-missing", "--copy"
      system "autoconf"
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
