require 'formula'

class Bitlbee < Formula
  url 'http://get.bitlbee.org/src/bitlbee-3.0.4.tar.gz'
  homepage 'http://www.bitlbee.org/'
  md5 '3eb1e3e30c015885c641503eec4b05cb'

  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libpurple' if ARGV.include? '--purple'

  def options
    [['--purple', "Use libpurple for all communication with instant messaging networks"]]
  end

  def install
    # By default Homebrew will set ENV['LD'] to the same as ENV['CC'] which
    # defaults to /usr/bin/cc (see Library/Homebrew/extend/ENV.rb:39) However
    # this will break as bitlbee uses one of those odd and rare Makefiles that
    # can't handle the linker being 'cc' and must be 'ld' (don't ask me some C
    # magician will know).
    ENV['LD'] = '/usr/bin/ld'

    args = ["--prefix=#{prefix}",
            "--debug=0",
            "--strip=0", # Let Homebrew handle the stripping
            "--ssl=gnutls",
            "--pidfile=#{var}/bitlbee/run/bitlbee.pid",
            "--config=#{var}/bitlbee/lib/",
            "--ipsocket=#{var}/bitlbee/run/bitlbee.sock"]

    args << "--purple=1" if ARGV.include? "--purple"

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
