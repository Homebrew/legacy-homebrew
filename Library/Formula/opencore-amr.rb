require 'formula'

class OpencoreAmr < Formula
  homepage 'http://opencore-amr.sourceforge.net/'
  url 'https://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.3.tar.gz'
  sha1 '737f00e97a237f4ae701ea55913bb38dc5513501'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
