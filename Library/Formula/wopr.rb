require 'formula'

class Wopr < Formula
  homepage 'http://ilk.uvt.nl/wopr'
  url 'http://software.ticc.uvt.nl/wopr-1.34.2.tar.gz'
  sha1 'da53c5dfbc9927a391481b9e56ffeceaf1aab0ff'

  depends_on 'pkg-config' => :build
  depends_on 'timbl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
