require 'formula'

class Spiped < Formula
  url 'http://www.tarsnap.com/spiped/spiped-1.1.0.tgz'
  homepage 'http://www.tarsnap.com/spiped.html'
  sha256 'b727b902310d217d56c07d503c4175c65387ff07c9cd50a24584903faf9f3dc3'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "LDADD", "-lcrypto"
      s.change_make_var! "BINDIR_DEFAULT", bin
    end

    system "bsdmake install"
  end
end
