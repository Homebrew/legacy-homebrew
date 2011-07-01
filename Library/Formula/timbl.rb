require 'formula'

class Timbl < Formula
  url 'http://ilk.uvt.nl/downloads/pub/software/timbl-6.3.0.tar.gz'
  homepage 'http://ilk.uvt.nl/timbl/'
  md5 '039febcd556cdd53da874e9d365224ca'

  depends_on 'pkg-config' => :build
  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
