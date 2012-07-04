require 'formula'

class Pngrewrite < Formula
  url 'http://entropymine.com/jason/pngrewrite/pngrewrite-1.3.0.zip'
  homepage 'http://entropymine.com/jason/pngrewrite/'
  md5 '37216932d12bf9b47dca1f45724080d6'

  depends_on :libpng

  def install
    system "#{ENV.cc} #{ENV.cflags} #{ENV.cppflags} -o pngrewrite pngrewrite.c #{ENV.ldflags} -lpng"
    bin.install 'pngrewrite'
  end
end
