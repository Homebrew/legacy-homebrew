require 'formula'

class Tpp < Formula
  url 'http://synflood.at/tpp/tpp-1.3.1.tar.gz'
  homepage 'http://synflood.at/tpp.html'
  md5 '35eebb38497e802df1faa57077dab2d1'

  def install
    inreplace 'Makefile' do |s| 
      s.change_make_var! "prefix", prefix
    end
    man.mkpath
    bin.mkpath
    system "make install"
  end
end