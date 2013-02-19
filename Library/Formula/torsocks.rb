require 'formula'

class Torsocks < Formula
  homepage 'https://gitweb.torproject.org/torsocks.git/'
  url 'https://git.torproject.org/torsocks.git', :tag => '1.3'
  version '1.3'
  head 'https://git.torproject.org/torsocks.git', :branch => 'master'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'tor'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/torsocks"
  end
end
