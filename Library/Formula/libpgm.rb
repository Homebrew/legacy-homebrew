require 'formula'

class Libpgm < Formula
  homepage 'http://code.google.com/p/openpgm/'
  url 'http://openpgm.googlecode.com/files/libpgm-5.2.121%7Edfsg.tar.gz'
  sha1 '8931d88af57067b8e27acf2e06f256a447986e26'
  version '5.2.121'

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
