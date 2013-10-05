require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.18.1/autogen-5.18.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.18.1/autogen-5.18.1.tar.gz'
  sha1 '53d29cafd187895f795e2ba94b9964f71da93060'

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
