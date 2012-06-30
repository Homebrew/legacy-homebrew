require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.2.3/sleuthkit-3.2.3.tar.gz'
  sha1 '85d100ffde54f051916a4ea9452563ff85fad4ac'

  head 'https://github.com/sleuthkit/sleuthkit.git'

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def patches
    # required for new-ish libewf releases (API change)
    # fixed in the upcoming sleuthkit 4.x
    if ARGV.build_stable?
      "http://downloads.sourceforge.net/project/libewf/patches%20for%203rd%20party%20software/sleuthkit/tsk3.2.3-libewf.patch"
    end
  end

  def install
    system "./bootstrap" if ARGV.build_head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
