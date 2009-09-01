require 'brewkit'

class Litmus <Formula
  @url='http://www.webdav.org/neon/litmus/litmus-0.12.1.tar.gz'
  @homepage='http://www.webdav.org/neon/litmus/'
  @md5='d0bbb717196e835a5759f67f097321fb'

  def install
    # Just basic options for now. We could use --with-ssl or alternative neon using dependency tracking?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
