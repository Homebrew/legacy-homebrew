require 'formula'

class Tlsdate < Formula
  homepage 'https://www.github.com/ioerror/tlsdate/'
  url 'https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.6.tar.gz'
  sha1 '7b0cbd73b81ee2775396724f42c0fb22f7020361'
  head 'https://github.com/ioerror/tlsdate.git'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build

  def install
    system './autogen.sh'
    system './configure', '--disable-dependency-tracking', "--prefix=#{prefix}"
    system 'make', 'install'
  end

  def test
    system 'tlsdate', '--verbose', '--dont-set-clock'
  end
end
