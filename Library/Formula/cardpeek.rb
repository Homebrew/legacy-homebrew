require 'formula'

class Cardpeek < Formula
  homepage 'https://cardpeek.googlecode.com'
  url 'https://cardpeek.googlecode.com/files/cardpeek-0.8.tar.gz'
  sha1 'f860936decbce1d8873efcd6e2668294be6c35fe'

  head 'http://cardpeek.googlecode.com/svn/trunk/'

  depends_on 'pkg-config' => :build
  depends_on :automake
  depends_on :x11
  depends_on 'gtk+3'
  depends_on 'lua52'

  def install
    # always run autoreconf, neeeded to generate configure for --HEAD,
    # and otherwise needed to reflect changes to configure.ac
    system "autoreconf -i"
    lua = Formula.factory("lua52")

    inreplace ['lua_asn1.c', 'lua_nodes.c', 'lua_bit.c', 'lua_bytes.c', 'lua_card.c', 'lua_crypto.c', 'lua_ext.c', 'lua_log.c', 'lua_ui.c'],
      'lauxlib.h', "#{lua.include}/lauxlib.h"

    inreplace ['lua_asn1.h', 'lua_bit.h', 'lua_bytes.h', 'lua_crypto.h', 'lua_card.h',  'lua_ext.c', 'lua_log.h', 'lua_ui.h', 'lua_nodes.h'],
      'lua.h', "#{lua.include}/lua.h"

    inreplace 'lua_ext.c', 'lualib.h', "#{lua.include}/lualib.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
