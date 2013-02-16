require 'formula'

class Tlsdate < Formula
  homepage 'https://www.github.com/ioerror/tlsdate/'
  url 'https://www.github.com/ioerror/tlsdate.git', :using => :git, :branch => 'master', :tag => '0.0.5'
  version '0.0.5'
  head 'https://www.github.com/ioerror/tlsdate.git', :using => :git, :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "tlsdate -v -n"
  end
end
