require 'formula'

class Bitlbee < Formula
  homepage 'http://www.bitlbee.org/'
  url 'http://get.bitlbee.org/src/bitlbee-3.0.5.tar.gz'
  md5 '9ff97260a2a7f3a7d102db158a8d9887'

  option 'purple', "Use libpurple for all communication with instant messaging networks"

  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libpurple' if build.include? 'purple'

  def install
    # By default Homebrew will set ENV['LD'] to the same as ENV['CC'] which
    # defaults to /usr/bin/cc (see Library/Homebrew/extend/ENV.rb:39) However
    # this will break as bitlbee uses one of those odd and rare Makefiles that
    # can't handle the linker being 'cc' and must be 'ld' (don't ask me some C
    # magician will know).
    ENV['LD'] = '/usr/bin/ld'

    args = ["--prefix=#{prefix}",
            "--debug=0",
            "--ssl=gnutls",
            "--pidfile=#{var}/bitlbee/run/bitlbee.pid",
            "--config=#{var}/bitlbee/lib/",
            "--ipsocket=#{var}/bitlbee/run/bitlbee.sock"]

    args << "--purple=1" if build.include? "purple"

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make install"
    # This build has an extra step.
    system "make install-etc"

    (var+"bitlbee/run").mkpath
    (var+"bitlbee/lib").mkpath
  end
end
