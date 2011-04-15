require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://sourceforge.net/projects/autogen/files/AutoGen/AutoGen-5.11.5/autogen-5.11.5.tar.bz2'
  md5 '51c841eab6114de22b55f77a1c4f85b8'

  depends_on 'guile'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make install"
  end
end
