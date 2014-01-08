require 'formula'

class Pstoedit < Formula
  homepage 'http://www.pstoedit.net'
  url 'http://downloads.sourceforge.net/project/pstoedit/pstoedit/3.62/pstoedit-3.62.tar.gz'
  sha1 '50d5a4e2fe0e0ff2f73cb094cb945b221083e742'

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
