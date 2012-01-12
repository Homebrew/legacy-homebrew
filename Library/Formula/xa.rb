require 'formula'

class Xa < Formula
  url 'http://www.floodgap.com/retrotech/xa/dists/xa-2.3.5.tar.gz'
  homepage 'http://www.floodgap.com/retrotech/xa/'
  md5 'edd15aa8674fb86225faf34e56d5cab2'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! 'DESTDIR', prefix
    end

    system "make"
    system "make install"
  end
end
