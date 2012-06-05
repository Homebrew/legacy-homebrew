require 'formula'

class Nrpe < Formula
  homepage 'http://www.nagios.org/'
  url 'http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.13/nrpe-2.13.tar.gz'
  md5 'e5176d9b258123ce9cf5872e33a77c1a'

  depends_on 'nagios-plugins'

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    inreplace 'configure', 'libssl.so', 'libssl.dylib'
    inreplace 'sample-config/nrpe.cfg.in', '/var/run/nrpe.pid', var+'run/nrpe.pid'
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{sbin}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--enable-ssl",
                          "--enable-command-args"
    system "make all"
    system "make install"
    system "make install-daemon-config"
    (var+'run').mkpath
  end

  def caveats
    <<-EOS.undent
    The nagios plugin check_nrpe has been installed in:
      #{HOMEBREW_PREFIX}/sbin

    You can start the daemon with
      #{bin}/nrpe -c #{etc}/nrpe.cfg -d
    EOS
  end
end
