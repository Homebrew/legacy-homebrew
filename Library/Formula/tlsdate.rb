require 'formula'

class Tlsdate < Formula
  homepage 'https://www.github.com/ioerror/tlsdate/'
  url 'https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.5.tar.gz'
  version '0.0.5'
  sha1sum 'b933d777c5d54ac4a5824f749d819ca884a1a2a9'
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
