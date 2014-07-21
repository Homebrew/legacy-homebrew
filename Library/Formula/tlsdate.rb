require 'formula'

class Tlsdate < Formula
  homepage 'https://www.github.com/ioerror/tlsdate/'
  head 'https://github.com/ioerror/tlsdate.git'
  url 'https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.7.tar.gz'
  sha1 '572ecdd4aa69f9bbcca47f9b12dcd22260838313'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system './autogen.sh'
    system './configure', '--disable-dependency-tracking', "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system "#{bin}/tlsdate", "--verbose", "--dont-set-clock"
  end
end
