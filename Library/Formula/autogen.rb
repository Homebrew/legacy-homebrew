require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.16.1/autogen-5.16.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.16.1/autogen-5.16.1.tar.gz'
  sha1 'a3a1aac9df966aabad39c68c01668bb2ba6be566'

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
