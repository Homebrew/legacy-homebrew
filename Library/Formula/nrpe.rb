require 'formula'

class Nrpe < Formula
  url 'http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.13/nrpe-2.13.tar.gz'
  homepage 'http://www.nagios.org/'
  md5 'e5176d9b258123ce9cf5872e33a77c1a'

  depends_on 'nagios-plugins'

  def plugins;  HOMEBREW_PREFIX+'sbin/nagios-plugins';  end
  def user;     `id -un`.chomp;                         end
  def group;    `id -gn`.chomp;                         end

  def install
    inreplace 'configure', 'libssl.so', 'libssl.dylib'
    inreplace 'sample-config/nrpe.cfg.in', '/var/run/nrpe.pid', var+'run/nrpe.pid'
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{plugins}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--enable-ssl",
                          "--enable-command-args"
    system "make all"
    system "make install"
    system "make install-daemon-config"
    mkdir_p var+'run'
  end

  def caveats
    <<-EOS.undent
    The nagios plugin check_nrpe has been installed into

      #{plugins}

    You can start the daemon with

      #{bin}/nrpe -c #{etc}/nrpe.cfg -d

    ...but you really should hand this task over to launchd.
    EOS
  end

  def test
    if `ps -A -o comm`.include? 'nrpe'
      system "#{plugins}/check_nrpe -H localhost"
    else
      onoe "NRPE not running. Please start it first!"
    end
  end
end
