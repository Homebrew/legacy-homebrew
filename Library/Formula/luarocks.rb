require 'formula'

class Luarocks <Formula
  url 'http://luarocks.org/releases/luarocks-2.0.2.tar.gz'
  homepage 'http://luarocks.org'
  md5 'f8b13b642f8bf16740cac009580cda48'

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

  def test
    opoo "Luarocks test script installs 'lpeg'"
    system "luarocks install lpeg"
    system "lua", "-lluarocks.loader", "-llpeg", "-e", 'print ("Hello World!")'
  end
end
