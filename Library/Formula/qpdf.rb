require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/qpdf/qpdf/5.1.1/qpdf-5.1.1.tar.gz'
  sha1 'e407a73bbaf6b1681e0952342e6d66a7746045c3'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{Formula["pcre"].opt_lib}"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
