require 'formula'

class Swfmill <Formula
  url 'http://swfmill.org/releases/swfmill-0.3.1.tar.gz'
  homepage 'http://swfmill.org'
  md5 '63c0b16eab55c385a47afe3ec5b917b9'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
