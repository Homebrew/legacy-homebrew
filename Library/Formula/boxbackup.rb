require 'formula'

class Boxbackup < Formula
  homepage 'http://www.boxbackup.org/'
  url 'http://www.boxbackup.org/export/3166/box/packages/boxbackup-0.11.1.tgz'
  sha1 '254253dbfc8cbfc2e5272d1e3589d4d73ccf3597'

  option 'install-client', "Install the bbackupd client"
  option 'install-server', "Install the bbstored server"

  depends_on :bsdmake => :build
  depends_on 'openssl' if MacOS.version == :leopard
  depends_on 'berkeley-db4'

  def install
    ENV.j1  # Unsure if needed, but FreeBSD port has it

    if !(build.include? 'install-client' or build.include? 'install-server')
      onoe 'You must choose --install-client, --install-server or both'
      exit -1
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "bsdmake"

    if build.include? 'install-client'
      plist_name = "homebrew.mxcl.boxbackup.bbackupd"
      plist_path.write "#{prefix}/homebrew.mxcl.boxbackup.bbackupd"
      inreplace "parcels/boxbackup-0.11.1-backup-client-darwin12.2.1/install-backup-client", "mkdir -p ${DESTDIR}/Library/LaunchDaemons/", ""
      inreplace "parcels/boxbackup-0.11.1-backup-client-darwin12.2.1/install-backup-client", "${DESTDIR}/Library/LaunchDaemons", "#{prefix}/homebrew.mxcl.bbackupd.plist"
      inreplace "parcels/boxbackup-0.11.1-backup-client-darwin12.2.1/org.boxbackup.bbackupd.plist", "org.boxbackup.bbackupd", "#{plist_name}"
      inreplace "parcels/boxbackup-0.11.1-backup-client-darwin12.2.1/org.boxbackup.bbackupd.plist", "/Cellar/boxbackup/0.11.1/", "/"
      inreplace "parcels/boxbackup-0.11.1-backup-client-darwin12.2.1/install-backup-client", "/man/", "/share/man/"
      inreplace "parcels/boxbackup-0.11.1-backup-client-darwin12.2.1/install-backup-client", "/doc/boxbackup-0.11.1-backup-client-darwin12.2.1", "/doc/boxbackup-client"
      system "bsdmake install-backup-client"
      mkdir_p "#{etc}/boxbackup/bbackupd"
    end

    if build.include? 'install-server'
      plist_name = "homebrew.mxcl.boxbackup.bbstored"
      plist_path.write "#{prefix}/homebrew.mxcl.boxbackup.bbstored"
      inreplace "parcels/boxbackup-0.11.1-backup-server-darwin12.2.1/install-backup-server", "mkdir -p ${DESTDIR}/Library/LaunchDaemons/", ""
      inreplace "parcels/boxbackup-0.11.1-backup-server-darwin12.2.1/install-backup-server", "${DESTDIR}/Library/LaunchDaemons", "#{prefix}/homebrew.mxcl.bbstored.plist"
      inreplace "parcels/boxbackup-0.11.1-backup-server-darwin12.2.1/org.boxbackup.bbstored.plist", "org.boxbackup.bbstored", "#{plist_name}"
      inreplace "parcels/boxbackup-0.11.1-backup-server-darwin12.2.1/org.boxbackup.bbstored.plist", "/Cellar/boxbackup/0.11.1/", "/"
      inreplace "parcels/boxbackup-0.11.1-backup-server-darwin12.2.1/install-backup-server", "/man/", "/share/man/"
      inreplace "parcels/boxbackup-0.11.1-backup-server-darwin12.2.1/install-backup-server", "/doc/boxbackup-0.11.1-backup-server-darwin12.2.1", "/doc/boxbackup-server"
      system "bsdmake install-backup-server"
      mkdir_p "#{etc}/boxbackup/bbstored"
    end

    # no idea where that extra plist file comes from, but we don't need it
    additional_plist = "#{prefix}/homebrew.mxcl.boxbackup.plist"
    rm additional_plist if File.exists? additional_plist

  end

  def test
    if build.include? 'install-server'
      system "#{sbin}/bbstored", "--version"
    end

    if build.include? 'install-client'
      system "#{sbin}/bbackupd", "--version"
    end
  end

  def caveats
    server = <<-EOS.undent

      Boxbackup Server (bbstored):
      ----------------------------
      Please see http://www.boxbackup.org/server.html for server configuration.

      To have launchd start bbstored at login:
          ln -sfv #{prefix}/homebrew.mxcl.bbstored.plist ~/Library/LaunchAgents
      Then to load bbstored:
          launchctl load ~/Library/LaunchAgents/homebrew.mxcl.bbstored.plist
      EOS


    client = <<-EOS.undent

      Boxbackup client (bbackupd):
      ----------------------------
      Please see http://www.boxbackup.org/client.html for client configuration.

      To have launchd start bbackupd at login:
          ln -sfv #{prefix}/homebrew.mxcl.bbackupd.plist ~/Library/LaunchAgents
      Then to load bbackupd:
          launchctl load ~/Library/LaunchAgents/homebrew.mxcl.bbackupd.plist
      EOS

    msg = ""

    if build.include? 'install-server'
      msg += server
    end

    if build.include? 'install-client'
      msg += client
    end

    # I dont't know how, but the generated caveat is wrong and should be overwritten:
    return msg + "\n" + "(ignore below caveat)\n"

  end

end
