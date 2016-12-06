require 'formula'

class Cryptofs <Formula
  url 'http://reboot78.re.funpic.de/cryptofs/cryptofs-0.6.0.tar.gz'
  homepage 'http://reboot78.re.funpic.de/cryptofs/'
  md5 '82094a525c6a95acd7bdab01e0595b5c'

  # depends_on 'cmake'
  depends_on 'libgcrypt'
  depends_on 'libgpg-error'
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'libfuse'
  depends_on 'libiconv'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
