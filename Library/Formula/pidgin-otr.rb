require 'formula'

class PidginOtr < Formula
  homepage 'https://otr.cypherpunks.ca'
  url 'https://otr.cypherpunks.ca/pidgin-otr-4.0.0.tar.gz'
  sha1 '23c602c4b306ef4eeb3ff5959cd389569f39044d'

  depends_on 'libotr4'
  depends_on 'pidgin'
  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",                          
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    homedir = ENV['HOME']
    plugin_dir = "#{homedir}/.purple/plugins"
    s = <<-EOS.undent
      This plugin won't be available until you symlink it into ~/.purple/plugins
          $ mkdir -p "#{plugin_dir}"
          $ ln -s "#{lib}/pidgin/pidgin-otr.so" "#{plugin_dir}"
    EOS
    s
  end

end
