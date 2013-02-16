require 'formula'

class Torsocks < Formula
  homepage 'https://gitweb.torproject.org/torsocks.git/'
  url 'https://git.torproject.org/torsocks.git', :using => :git, :branch => 'master', :tag => '1.3'
  version '1.3'
  head 'https://git.torproject.org/torsocks.git', :using => :git, :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'tor'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "torsocks"
  end
end
