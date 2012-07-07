require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.2.3/sleuthkit-3.2.3.tar.gz'
  sha1 '85d100ffde54f051916a4ea9452563ff85fad4ac'

  head 'https://github.com/sleuthkit/sleuthkit.git'

  if ARGV.build_head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

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
