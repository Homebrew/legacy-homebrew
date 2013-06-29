require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.17.3/autogen-5.17.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.17.3/autogen-5.17.3.tar.gz'
  sha1 '90c287c6d255c68bb3d7233e31672f0be8c38d07'

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
