require 'formula'

class Spiped < Formula
  url 'http://www.tarsnap.com/spiped/spiped-1.0.0.tgz'
  homepage 'http://www.tarsnap.com/spiped.html'
  sha256 '82df05533bf8d8580f57e6dbec7d7e2966eabd3ea7a0a0bb06f87000947969a3'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "LDADD", "-lcrypto"
      s.change_make_var! "BINDIR_DEFAULT", bin
    end

    system "bsdmake install"
  end
end
