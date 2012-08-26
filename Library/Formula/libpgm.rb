require 'formula'

class Libpgm < Formula
  homepage 'http://code.google.com/p/openpgm/'
  url 'http://openpgm.googlecode.com/files/libpgm-5.2.119%7Edfsg.tar.gz'
  sha1 '8ac7e61716a7911ec8c1608cea8cf59d841b2d9d'
  version '5.2.119'

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
