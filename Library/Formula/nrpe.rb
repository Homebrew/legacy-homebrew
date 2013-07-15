require 'formula'

class Nrpe < Formula
  homepage 'http://www.nagios.org/'
  url 'http://sourceforge.net/projects/nagios/files/nrpe-2.x/nrpe-2.14/nrpe-2.14.tar.gz'
  sha1 'e5c827c250d2b836f850c99e17c744f9c626472b'

  depends_on 'nagios-plugins'

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

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
