require 'formula'

class Qpdf < Formula
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/2.3.1/qpdf-2.3.1.tar.gz'
  homepage 'http://qpdf.sourceforge.net/'
  sha1 '043cceeb74a702d4e6a6a83b0211d99f28383655'

  depends_on 'pcre'

  def patches
    # Fix call to depreciated PCRE function. Can probably be removed on next
    # release. Upstream issue:
    #   http://sourceforge.net/tracker/?func=detail&aid=3489349&group_id=224196&atid=1060899
    'http://sourceforge.net/tracker/download.php?group_id=224196&atid=1060899&file_id=436172&aid=3489349'
  end

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
