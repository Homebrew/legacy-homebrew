require 'brewkit'

class Luarocks <Formula
  @url='http://luaforge.net/frs/download.php/3981/luarocks-1.0.1.tar.gz'
  @homepage='http://luarocks.org'
  @md5='e6fad9ddecf79808fda7fd257bfbde06'

  depends_on 'lua'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
