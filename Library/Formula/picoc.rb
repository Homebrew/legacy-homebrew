require 'formula'

class Picoc < Formula
  url 'http://picoc.googlecode.com/files/picoc-2.1.tar.bz2'
  homepage 'http://code.google.com/p/picoc/'
  md5 '6505fb108d195bad0854c7024993cc24'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! 'CC', ENV['CC']
      s.change_make_var! 'CFLAGS', ENV['CFLAGS'] + ' -DUNIX_HOST'
    end

    system "make"
    bin.install "picoc"
  end
end
