require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.17.1/autogen-5.17.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.17.1/autogen-5.17.1.tar.gz'
  sha1 '089b13c93a6ac2c5ef9993fc2c8e516683fcea8e'

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
