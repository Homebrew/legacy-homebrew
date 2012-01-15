require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.14/autogen-5.14.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.14/autogen-5.14.tar.gz'
  md5 '149a34b34cb071153317bb43d4984ec7'

  depends_on 'guile'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make install"
  end
end
