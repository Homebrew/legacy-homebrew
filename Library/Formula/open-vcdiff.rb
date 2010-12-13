require 'formula'

class OpenVcdiff <Formula
  url 'http://open-vcdiff.googlecode.com/files/open-vcdiff-0.7.tar.gz'
  homepage 'http://code.google.com/p/open-vcdiff/'
  md5 'c6a3f29311d937911f508b8a474b5f57'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
