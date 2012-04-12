require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.15/autogen-5.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.15/autogen-5.15.tar.gz'
  md5 '2e77ddd723433bef4adc644c93553c3d'

  depends_on 'guile'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make install"
  end
end
