require 'formula'

class Swfmill <Formula
  url 'http://swfmill.org/releases/swfmill-0.2.12.tar.gz'
  homepage 'http://swfmill.org'
  md5 '88a634cad4d8d025c84c6e8916a8b1c4'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
