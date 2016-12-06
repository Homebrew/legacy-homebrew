require 'formula'

class Libvarbit < Formula
  url 'git://github.com/mschneider/libvarbit.git', :tag => 'bb82666ebc85996649ed11e9ee371f157e0777f6'
  head 'git://github.com/mschneider/libvarbit.git'
  version '0.1'
  homepage 'https://github.com/mschneider/libvarbit/'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
    end
    system "make", "install"
  end
end
