require 'formula'

class Convertlit < Formula
  homepage 'http://www.convertlit.com/'
  url 'http://www.convertlit.com/clit18src.zip'
  md5 'd691d4729485fe5d73e3f0937d8fb42e'
  version '1.8'

  depends_on 'libtommath'

  def install
    inreplace 'clit18/Makefile' do |s|
      s.gsub! "-I ../libtommath-0.30", "#{HOMEBREW_PREFIX}/include"
      s.gsub! "../libtommath-0.30/libtommath.a", "#{HOMEBREW_PREFIX}/lib/libtommath.a"
    end

    cd "lib" do
      system "make"
    end

    cd "clit18" do
      system "make"
      bin.install 'clit'
    end
  end
end
