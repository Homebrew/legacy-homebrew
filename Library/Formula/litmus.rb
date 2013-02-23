require 'formula'

class Litmus < Formula
  homepage 'http://www.webdav.org/neon/litmus/'
  url 'http://www.webdav.org/neon/litmus/litmus-0.13.tar.gz'
  sha1 '42ad603035d15798facb3be79b1c51376820cb19'

  def install
    # Just basic options for now. We could use --with-ssl or alternative neon using dependency tracking?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
