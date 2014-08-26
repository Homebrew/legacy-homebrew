require 'formula'

class Torsocks < Formula
  homepage 'https://gitweb.torproject.org/torsocks.git/'
  url 'https://git.torproject.org/torsocks.git', :tag => 'v2.0.0'

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

  test do
    system "#{bin}/torsocks", "--help"
  end
end
