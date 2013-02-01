require 'formula'

class Bitlbee < Formula
  homepage 'http://www.bitlbee.org/'
  url 'http://get.bitlbee.org/src/bitlbee-3.2.tar.gz'
  sha1 '21e17f082c776566429603b1e8c966983a75ac9e'

  option 'with-libpurple', "Use libpurple for all communication with instant messaging networks"
  option 'with-libotr', "Build with otr (off the record) support"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'libpurple' => :optional
  depends_on 'libotr' => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--debug=0",
            "--ssl=gnutls",
            "--pidfile=#{var}/bitlbee/run/bitlbee.pid",
            "--config=#{var}/bitlbee/lib/",
            "--ipsocket=#{var}/bitlbee/run/bitlbee.sock"]

    args << "--purple=1" if build.with? "libpurple"
    args << "--otr=1" if build.with? "libotr"

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make install"
    # Install the dev headers too
    system "make install-dev"
    # This build has an extra step.
    system "make install-etc"

    (var+"bitlbee/run").mkpath
    (var+"bitlbee/lib").mkpath
  end
end
