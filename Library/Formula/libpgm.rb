require 'formula'

class Libpgm < Formula
  homepage 'http://code.google.com/p/openpgm/'
  url 'http://openpgm.googlecode.com/files/libpgm-5.2.122%7Edfsg.tar.gz'
  sha1 '788efcb223a05bb68b304bcdd3c37bb54fe4de28'
  version '5.2.122'

  option :universal

  def install
    cd 'openpgm/pgm' do
      ENV.universal_binary if build.universal?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end
end
