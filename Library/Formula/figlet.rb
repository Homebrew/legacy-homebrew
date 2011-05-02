require 'formula'

class ContribFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/contributed.tar.gz'
  version "2.2.2"
  md5 '6e2dec4499f7a7fe178522e02e0b6cd1'
end

class InternationalFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/international.tar.gz'
  version "2.2.2"
  md5 'b2d53f7e251014adcdb4d407c47f90ef'
end

class Figlet < Formula
  url 'ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.4.tar.gz'
  homepage 'http://www.figlet.org'
  md5 'ea048d8d0b56f9c58e55514d4eb04203'

  def fonts
    share + "figlet/fonts"
  end

  def install
    File.chmod 0666, 'Makefile'
    File.chmod 0666, 'showfigfonts'
    man6.mkpath
    bin.mkpath

    ContribFonts.new.brew { fonts.install Dir['*'] }
    InternationalFonts.new.brew { fonts.install Dir['*'] }

    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/", "#{prefix}/"
      s.change_make_var! 'DEFAULTFONTDIR', fonts
      s.change_make_var! 'MANDIR', man6
    end

    system "make install"
  end
end