require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'http://binwalk.googlecode.com/files/binwalk-1.1.tar.gz'
  sha1 'd2a6b076bc748ef1dc97304233bc36dfbbe59098'

  depends_on 'libmagic'

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
