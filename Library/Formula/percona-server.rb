require 'formula'

class PerconaServer < Formula
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.1/Percona-Server-5.1.58-12.9/source/Percona-Server-5.1.58.tar.gz'
  homepage 'http://www.percona.com/software/percona-server/'
  md5 'd5960629d4a3c4b4bdf7e40be6d40525'

  def install
    # Make sure the var/mysql directory exists
    (var+"mysql").mkpath

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-community-features", "--enable-profiling", "--enable-local-infile",
                          "--with-plugins=max-no-ndb",
                          "--prefix=#{prefix}", "--localstatedir=#{var}/mysql",
                          "--mandir=#{man}", "--infodir=#{info}"
    system "make"
    system "make install"

    (prefix+'com.mysql.mysqld.plist').write startup_plist
    (prefix+'com.mysql.mysqld.plist').chmod 0644

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    # Change the mysqld_safe script to use your user, since you control the data
    inreplace "#{bin}/mysqld_safe", "user='mysql'", "user='#{`whoami`.chomp}'"
  end

  def caveats; <<-EOS.undent
    Set up databases to run AS YOUR USER ACCOUNT with:
        unset TMPDIR
        mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix #{name})" --datadir=#{var}/mysql --tmpdir=/tmp

    To set up base tables in another folder, or use a different user to run
    mysqld, view the help for mysqld_install_db:
        mysql_install_db --help

    In case the install step fails on inserting help, after starting mysql manually, run:
        shell> mysql -uroot mysql
        mysql> source #{share}/mysql/fill_help_tables.sql

    and view the MySQL documentation:
      * http://dev.mysql.com/doc/refman/5.1/en/mysql-install-db.html
      * http://dev.mysql.com/doc/refman/5.1/en/default-privileges.html

    To run as, for instance, user "mysql", you may need to `sudo`:
        sudo mysql_install_db ...options...

    Start mysqld manually with:
        #{libexec}/mysqld

        Note: if this fails, you probably forgot to run the first two steps up above

    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
        mysql -uroot

    To launch on startup:
    * if this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/com.mysql.mysqld.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

    * if this is an upgrade and you already have the com.mysql.mysqld.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/com.mysql.mysqld.plist
        cp #{prefix}/com.mysql.mysqld.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

    You may also need to edit the plist to use the correct "UserName".

    EOS
  end

  def startup_plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>com.mysql.mysqld</string>
      <key>Program</key>
      <string>#{bin}/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOPLIST
  end
end
