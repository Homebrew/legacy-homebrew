require 'formula'

class Luarocks <Formula
  url 'http://luarocks.org/releases/luarocks-2.0.2.tar.gz'
  homepage 'http://luarocks.org'
  md5 'f8b13b642f8bf16740cac009580cda48'

  depends_on 'lua'

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    # Configure can detect 'wget' to use as a downloader, but we don't
    # require it since curl works too and comes with OS X.
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
