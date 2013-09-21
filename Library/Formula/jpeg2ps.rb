require 'formula'

class Jpeg2ps < Formula
  homepage 'http://www.pdflib.com/download/free-software/jpeg2ps/'
  url 'http://www.pdflib.com/fileadmin/pdflib/products/more/jpeg2ps/jpeg2ps-1.9.tar.gz'
  sha1 '2fc2701c7c00ba17b051ebcc7b9c8059eb6614f9'

  def install
    bin.mkpath
    man.mkpath
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    # not terribly robust
    testfile = `find /Library -name '*.jpg' | head -n 1`
    testfile.strip!
    system "#{bin}/jpeg2ps", testfile
  end
end
