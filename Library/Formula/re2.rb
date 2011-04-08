require 'formula'

class Re2 < Formula
  head 'https://re2.googlecode.com/hg'
  homepage 'http://code.google.com/p/re2/'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "prefix", prefix
      s.gsub! ".so", ".dylib"
    end

    lib.mkdir
    system "make"
    system "make install"
  end
end
