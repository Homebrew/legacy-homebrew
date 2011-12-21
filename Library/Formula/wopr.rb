require 'formula'

class Wopr < Formula
  url 'http://ilk.uvt.nl/downloads/pub/software/wopr-1.31.8.tar.gz'
  homepage 'http://ilk.uvt.nl/wopr'
  md5 '5a7c9c756ab21fcb861d51e1d402e85a'

  depends_on 'timbl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
