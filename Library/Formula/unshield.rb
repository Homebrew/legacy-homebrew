require 'formula'

class Unshield < Formula
  homepage 'http://www.synce.org/oldwiki/index.php/Unshield'
  url 'http://downloads.sourceforge.net/project/synce/Unshield/0.6/unshield-0.6.tar.gz'
  sha1 '3e1197116145405f786709608a5a636a19f4f3e1'

  # Add support for new Installshield versions. See:
  # http://sourceforge.net/tracker/?func=detail&aid=3163039&group_id=30550&atid=399603
  def patches
    "http://patch-tracker.debian.org/patch/series/dl/unshield/0.6-3/new_installshield_format.patch"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
