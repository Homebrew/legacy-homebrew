require 'formula'

class Exvi < Formula
  url 'http://sourceforge.net/projects/ex-vi/files/ex-vi/050325/ex-050325.tar.bz2'
  homepage 'http://ex-vi.sourceforge.net/'
  md5 'e668595254233e4d96811083a3e4e2f3'
  version '050325'

  def install
    preserve = "#{var}/preserve"
    inreplace 'Makefile' do |s|
      s.change_make_var! 'PREFIX', prefix
      s.change_make_var! 'PRESERVEDIR', preserve
      s.change_make_var! 'INSTALL', `which install`.chomp
    end
    ENV.j1
    system "make", "install"
    mkdir preserve unless File.exists? preserve
  end
end
