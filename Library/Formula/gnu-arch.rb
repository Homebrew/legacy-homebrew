require 'formula'

class GnuArch < Formula
  homepage 'http://www.gnu.org/software/gnu-arch/'
  url 'http://ftpmirror.gnu.org/gnu-arch/tla-1.3.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gnu-arch/tla-1.3.5.tar.gz'
  md5 'db31ee89bc4788eef1eba1cee6c176ef'

  def install
    mkdir "build" do
      system "../src/configure", "--prefix=#{prefix}"
      ENV.j1 # don't run make in parallel
      system "make"
      system "make install"
    end
  end

  def test
    system "#{bin}/tla", "-V"
  end
end
