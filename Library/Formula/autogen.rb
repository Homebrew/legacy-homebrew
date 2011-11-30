require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.12/autogen-5.12.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.12/autogen-5.12.tar.bz2'
  md5 '126e56be629cda747390e8ba9be71e4b'

  depends_on 'guile'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make install"
  end
end
