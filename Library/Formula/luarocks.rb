require 'formula'

class Luarocks <Formula
  @url='http://luaforge.net/frs/download.php/3981/luarocks-1.0.1.tar.gz'
  @homepage='http://luarocks.org'
  @md5='e6fad9ddecf79808fda7fd257bfbde06'

  depends_on 'lua'
  # wget or curl can be used as the downloader...
  # depends_on 'wget' => :optional

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    system "./configure", "--prefix=#{prefix}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}/lib/luarocks",
                          "--sysconfdir=#{etc}/luarocks"
    system "make"
    system "make install"
  end
end
