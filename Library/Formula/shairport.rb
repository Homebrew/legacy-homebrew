require 'formula'

class Shairport < Formula
  head 'https://github.com/albertz/shairport.git'
  homepage 'https://github.com/albertz/shairport'

  depends_on 'libao'

  def install
    system "mkdir #{bin}"
    inreplace 'Makefile' do |s|
      s.change_make_var! 'prefix', prefix
      s.gsub! 'install -D', 'install'
    end
    system "make install"
  end

  def test
    system "shairport --help"
  end
end
