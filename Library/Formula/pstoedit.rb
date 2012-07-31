require 'formula'

class Pstoedit < Formula
  homepage 'http://www.pstoedit.net'
  url 'https://sourceforge.net/projects/pstoedit/files/pstoedit/3.60/pstoedit-3.60.tar.gz/download'
  sha1 '649ade3d873429548eb6dd9f3e13cb79a8d6a1a2'

  depends_on 'pkg-config' => :build
  depends_on 'plotutils'
  depends_on 'ghostscript'
  depends_on 'imagemagick'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
