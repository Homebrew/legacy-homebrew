require 'formula'

class Wy60 < Formula
  homepage 'https://code.google.com/p/wy60/'
  url 'https://wy60.googlecode.com/files/wy60-2.0.9.tar.gz'
  sha1 'ea0b10fe0560bd8b98115d40890b9530edf44cb4'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
