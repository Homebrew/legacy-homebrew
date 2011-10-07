require 'formula'

class Pms < Formula
  url 'https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2'
  homepage 'http://pms.sourceforge.net'
  md5 '8ebd65c5e6e33cd0ca79817a5e823805'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
