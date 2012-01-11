require 'formula'

class Zeromq < Formula
  url 'http://download.zeromq.org/zeromq-2.1.11.tar.gz'
  homepage 'http://www.zeromq.org/'
  md5 'f0f9fd62acb1f0869d7aa80379b1f6b7'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
