require 'formula'

class Wopr < Formula
  url 'http://ilk.uvt.nl/downloads/pub/software/wopr-1.31.8.tar.gz'
  homepage 'http://ilk.uvt.nl/wopr'
  md5 'cd9f79f46fc6f6c305b3fe1fed219ee1'

  depends_on 'pkg-config' => :build
  depends_on 'timbl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
