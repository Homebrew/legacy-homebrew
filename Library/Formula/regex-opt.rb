require 'formula'

class RegexOpt < Formula
  homepage 'http://bisqwit.iki.fi/source/regexopt.html'
  url 'http://bisqwit.iki.fi/src/arch/regex-opt-1.2.2.tar.bz2'
  sha1 '18481500e8fed8ecf94f9738104594ef5a658456'

  def install
    inreplace 'Makefile' do |f|
      f.gsub! 'gcc', ENV.cc
      f.gsub! 'g++', ENV.cxx
    end

    system "make"
    bin.install 'regex-opt'
  end

  def test
    system "#{bin}/regex-opt"
  end
end
