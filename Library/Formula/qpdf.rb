require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/5.1.0/qpdf-5.1.0.tar.gz'
  sha1 'a2aafad5c49efb62e98e6895bb96ca423179bf43'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{Formula.factory('pcre').opt_prefix}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
