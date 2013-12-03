require 'formula'

class Fwknop < Formula
  homepage 'http://www.cipherdyne.org/fwknop/'
  head 'https://github.com/mrash/fwknop.git'
  url 'https://github.com/mrash/fwknop/archive/2.5.1.1.tar.gz'
  sha1 '47adc5734dfc84f9ab6e2ba8a5097132519cab8a'

  depends_on :automake
  depends_on :autoconf
  depends_on :libtool

  depends_on 'gpgme' => :optional

  def install
    system './autogen.sh' if build.head? or !File.exists?('configure')
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fwknop", "--version"
  end
end
