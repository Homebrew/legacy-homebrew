require 'formula'

class PidginOtr < Formula
  homepage 'http://www.cypherpunks.ca/otr/'
  url 'http://www.cypherpunks.ca/otr/pidgin-otr-4.0.0.tar.gz'
  sha1 '23c602c4b306ef4eeb3ff5959cd389569f39044d'

  depends_on 'libotr'
  depends_on 'pidgin'
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # pidgin likely compiled in a manner whereby it checks its
    # Cellar directory for the plugin libs. Hence, when pidgin-otr
    # is compiled, and then linked into the global lib dir, pidgin
    # will not find the plugin. So we have:
    ln_s "#{Formula.factory('pidgin-otr').lib}/pidgin/pidgin-otr.so", "#{Formula.factory('pidgin').lib}/pidgin/pidgin-otr.so"
    # Alternatively someone could update the pidgin.rb installation
    # so that it indeed looks to the global libs dir for plugins.
  end
end
