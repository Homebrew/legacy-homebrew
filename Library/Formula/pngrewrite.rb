require 'formula'

class Pngrewrite < Formula
  url 'http://entropymine.com/jason/pngrewrite/pngrewrite-1.3.0.zip'
  homepage 'http://entropymine.com/jason/pngrewrite/'
  sha1 '0a2a56c53e7b4cd0502c897092e859e92128d1bd'

  depends_on :libpng

  def install
    system "#{ENV.cc} #{ENV.cflags} #{ENV.cppflags} -o pngrewrite pngrewrite.c #{ENV.ldflags} -lpng"
    bin.install 'pngrewrite'
  end
end
