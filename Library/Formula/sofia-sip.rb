require 'formula'

class SofiaSip < Formula
  homepage 'http://sofia-sip.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz'
  sha1 'fe11c98fae19cbdbd7e55876c5553c1f9a0c561d'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
