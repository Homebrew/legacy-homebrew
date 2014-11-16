require 'formula'

class Libpgm < Formula
  homepage 'http://code.google.com/p/openpgm/'
  url 'https://openpgm.googlecode.com/files/libpgm-5.2.122%7Edfsg.tar.gz'
  sha1 '788efcb223a05bb68b304bcdd3c37bb54fe4de28'
  version '5.2.122'

  bottle do
    cellar :any
    revision 1
    sha1 "6e6e3733c7d612a7632e602191f06698ab8e57a3" => :yosemite
    sha1 "0c0e8cd6d5ac936c9f4c40cc0b83e1ddc2398d6d" => :mavericks
    sha1 "c68362f62ee7796ed3fbea2f6d93480fd7f6564d" => :mountain_lion
  end

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
