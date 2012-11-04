require 'formula'

class Pngrewrite < Formula
  homepage 'http://entropymine.com/jason/pngrewrite/'
  url 'http://entropymine.com/jason/pngrewrite/pngrewrite-1.4.0.zip'
  sha1 'c959fbd507d84c6d4544d09493934b268e969b56'

  depends_on :libpng

  def install
    inreplace 'Makefile' do |f|
      f.gsub! 'gcc', ENV.cc
      f.gsub! '-Wall -O2', ENV.cflags
    end
    system 'make'
    bin.install 'pngrewrite'
  end
end
