require 'formula'

class Exmpp < Formula
  homepage 'https://support.process-one.net/doc/display/EXMPP/'
  url 'https://github.com/processone/exmpp/archive/v0.9.9.tar.gz'
  sha1 'a9bf33a2942c5b84e8a97d7ba97eb33d5383896e'

  depends_on :automake
  depends_on :autoconf
  depends_on :libtool
  depends_on 'expat'
  depends_on 'erlang'

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "echo 'exmpp:version().' | erl -run exmpp start |grep '#{version}'"
  end
end
