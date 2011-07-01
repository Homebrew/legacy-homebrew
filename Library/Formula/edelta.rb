require 'formula'

class Edelta < Formula
  url 'http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/edelta-0.10b.tar.gz'
  homepage 'http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/'
  md5 'f0306c9bca4518d86a08d8a4f98a9ca8'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end
    system "make"
    bin.install 'edelta'
  end
end
