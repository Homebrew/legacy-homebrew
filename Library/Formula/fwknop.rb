require 'formula'

class Fwknop < Formula
  homepage 'http://www.cipherdyne.org/fwknop/'
  head 'https://github.com/mrash/fwknop.git'
  url 'https://github.com/mrash/fwknop/archive/2.6.2.tar.gz'
  sha1 '3e518d3db0831061b027475869c77a7ff304219e'

  depends_on :automake
  depends_on :autoconf
  depends_on :libtool

  depends_on 'gpgme'

  def install
    system './autogen.sh' if build.head? or !File.exist?('configure')
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gpgme"
    system "make install"
  end

  test do
    system "#{bin}/fwknop", "--version"
  end
end
