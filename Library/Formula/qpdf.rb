require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/5.0.0/qpdf-5.0.0.tar.gz'
  sha1 'b2d15a1499ed98430a6248d4d8960f43474b8948'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
