require 'formula'

class Libpgm < Formula
  homepage 'http://code.google.com/p/openpgm/'
  url 'https://openpgm.googlecode.com/files/libpgm-5.2.122%7Edfsg.tar.gz'
  sha1 '788efcb223a05bb68b304bcdd3c37bb54fe4de28'
  version '5.2.122'

  bottle do
    cellar :any
    sha1 "a6ef54c95ebc2839235e41d0efc707b2dd666a18" => :mavericks
    sha1 "6e0993c5ce4ae20d1602564e3d52b27e7e3deccd" => :mountain_lion
    sha1 "7d25ac41693edf40af6618b411a8e054f0f6c38b" => :lion
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
