require 'formula'

class PidginOtr < Formula
  homepage 'http://otr.cypherpunks.ca/'
  url 'http://www.cypherpunks.ca/otr/pidgin-otr-4.0.0.tar.gz'
  sha1 '23c602c4b306ef4eeb3ff5959cd389569f39044d'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libotr'
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'pidgin'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  def caveats
    message = <<-EOS
In order for pidgin to use the otr plugin, a link to the otr plugin must be
created as follows:

ln -s $(brew --cellar)/pidgin-otr/4.0.0/lib/pidgin/pidgin-otr.so $(brew --cellar)/pidgin/VERSION/lib/pidgin/pidgin-otr.so

Note that VERSION must be replaced with the installed pidgin version!

EOS
  end
end
