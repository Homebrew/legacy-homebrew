require 'formula'

class ModSuexec < Formula
  version "2.2.20"
  url 'http://archive.apache.org/dist/httpd/httpd-2.2.20.tar.gz'
  homepage 'http://httpd.apache.org/docs/current/suexec.html'
  md5 '4504934464c5ee51018dbafa6d99810d'

  def install
    docroot   = '/Library/WebServer/Documents'
    logfile   = '/private/var/log/apache2/suexec_log'
    begin
      suexecbin = `/usr/sbin/apachectl -V`.match(/SUEXEC_BIN="(.+)"/)[1]
    rescue # This should never happen, unless Apple drops support for suexec in the future...
      abort "Could not determine suexec path. Are you sure that Apache has been compiled with suexec support?" unless suexecbin
    end
    system "./configure",
      "--enable-suexec=shared",
      "--with-suexec-bin=#{suexecbin}",
      "--with-suexec-caller=_www",
      "--with-suexec-userdir=Sites",
      "--with-suexec-docroot=#{docroot}",
      "--with-suexec-uidmin=500",
      "--with-suexec-gidmin=20",
      "--with-suexec-logfile=#{logfile}",
      "--with-suexec-safepath='/usr/local/bin:/usr/bin:/bin:/opt/local/bin'"
    system "make"
    libexec.install 'modules/generators/.libs/mod_suexec.so'
    include.install 'modules/generators/mod_suexec.h'
    bin.install 'support/suexec'
  end

  def caveats
    suexecbin = `/usr/sbin/apachectl -V`.match(/SUEXEC_BIN="(.+)"/)[1]
    <<-EOS.undent
      To complete the installation, execute the following commands:
        sudo cp #{bin}/suexec #{File.dirname(suexecbin)}
        sudo chown root #{suexecbin}
        sudo chgrp _www #{suexecbin}
        sudo chmod 4750 #{suexecbin}

      Then, you need to edit /etc/apache2/httpd.conf to add the following line:
        LoadModule suexec_module #{libexec}/mod_suexec.so

      Upon restarting Apache, you should see the following message in the error log:
        [notice] suEXEC mechanism enabled (wrapper: #{suexecbin})

      Please, be sure to understand the security implications of suexec
      by carefully reading http://httpd.apache.org/docs/current/suexec.html.
    EOS
  end

end
