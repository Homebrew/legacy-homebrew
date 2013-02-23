require 'formula'

class Tlsdate < Formula
  homepage 'https://www.github.com/ioerror/tlsdate/'
  url 'https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.6.tar.gz'
  sha1 '7b0cbd73b81ee2775396724f42c0fb22f7020361'
  head 'https://www.github.com/ioerror/tlsdate.git', :branch => 'master'

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
