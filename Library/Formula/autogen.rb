require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.16.2/autogen-5.16.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.16.2/autogen-5.16.2.tar.gz'
  sha1 '55c5e3c18c77a9de14cce8044f5848a614f4ed66'

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
