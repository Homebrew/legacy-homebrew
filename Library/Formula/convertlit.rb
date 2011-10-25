require 'formula'

class Convertlit < Formula
  url 'http://www.convertlit.com/clit18src.zip'
  homepage 'http://www.convertlit.com/'
  md5 'd691d4729485fe5d73e3f0937d8fb42e'
  version '1.8'

  depends_on 'libtommath'

  def install
    inreplace 'clit18/Makefile' do |s|
      s.gsub! "-I ../libtommath-0.30", "#{HOMEBREW_PREFIX}/include"
      s.gsub! "../libtommath-0.30/libtommath.a", "#{HOMEBREW_PREFIX}/lib/libtommath.a"
    end

    Dir.chdir "lib"
    system "make"
    Dir.chdir "../clit18"
    system "make"

    bin.install 'clit'
  end
end
