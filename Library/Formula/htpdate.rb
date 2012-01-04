require 'formula'

class Htpdate < Formula
  url 'http://www.clevervest.com/htp/archive/c/htpdate-0.9.1.tar.gz'
  homepage 'http://www.clevervest.com/htp'
  md5 '26f9792ded592e2dd79a6c26d436a4ed'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'prefix', prefix
      s.change_make_var! 'STRIP', "/usr/bin/strip"
    end

    system "make"
    system "make install"
  end

  def test
    system "htpdate -h"
  end
end
