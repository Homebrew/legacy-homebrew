require 'formula'

class Litmus < Formula
  url 'http://www.webdav.org/neon/litmus/litmus-0.12.1.tar.gz'
  homepage 'http://www.webdav.org/neon/litmus/'
  sha1 '05ddd13b0afdc9b65e0340d6ba48ebaa719b8efb'

  def install
    # Just basic options for now. We could use --with-ssl or alternative neon using dependency tracking?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
