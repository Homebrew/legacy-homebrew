require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.17.2/autogen-5.17.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.17.2/autogen-5.17.2.tar.gz'
  sha1 '90c0819e5716df9b9c04385435778e4505cb111f'

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
