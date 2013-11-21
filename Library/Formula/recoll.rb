require 'formula'

class Recoll < Formula
  homepage 'http://www.recoll.org'
  url 'http://www.recoll.org/recoll-1.19.9.tar.gz'
  sha1 'ab662057082eb889b196653c328440ed95bf9ac4'

  depends_on 'xapian'
  depends_on 'qt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/recollindex", "-h"
  end
end
