require 'formula'

class SblimSfcc < Formula
  version  "2.2.5-1"
  homepage 'https://sourceforge.net/projects/sblim/'
  url      'https://github.com/jameskyle/sblim-sfcc/archive/SFCC_2_2_5.tar.gz'
  sha1     '963954b27db729e0cf702e018128602ef764c668'

  depends_on :libtool
  depends_on :autoconf
  depends_on :automake
  
  def patches
    # Patch sblim-sfcc to compile on osx
    'https://github.com/jameskyle/sblim-sfcc/commit/7a3e7f7f436f5e4e03824104330c79c4dbb157fb.patch'
  end

  def install
    system "./autoconfiscate.sh"
    system "./configure","--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
