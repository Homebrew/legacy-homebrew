require 'formula'

class Boxbackup < Formula
  homepage 'http://www.boxbackup.org/'
  url 'http://www.boxbackup.org/export/3166/box/packages/boxbackup-0.11.1.tgz'
  sha1 '254253dbfc8cbfc2e5272d1e3589d4d73ccf3597'

  option 'no-client', "Don't install the bbackupd client"
  option 'no-server', "Don't install the bbstored server"

  depends_on :bsdmake => :build
  depends_on 'openssl' if MacOS.version == :leopard
  depends_on 'berkeley-db4'

  def install
    ENV.j1  # Unsure if needed, but FreeBSD port has it

    if (build.include? 'no-client' and build.include? 'no-server')
      onoe 'You cannot use both --no-client and --no-server.'
      exit -1
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"

    if !build.include? 'no-client'
      system "bsdmake build-backup-client"
      sbin.install 'release/bin/bbackupctl/bbackupctl', 'release/bin/bbackupd/bbackupd', 'bin/bbackupd/bbackupd-config', 'release/bin/bbackupquery/bbackupquery'
      man5.install 'docs/man/bbackupd.conf.5.gz'
      man8.install 'docs/man/bbackupd.8.gz', 'docs/man/bbackupctl.8.gz', 'docs/man/bbackupd-config.8.gz', 'docs/man/bbackupquery.8.gz'
      mkdir_p "#{etc}/boxbackup/bbackupd"
      chmod 0700, "#{etc}/boxbackup/bbackupd"
    end

    if !build.include? 'no-server'
      system "bsdmake build-backup-server"
      sbin.install 'release/bin/bbstoreaccounts/bbstoreaccounts', 'release/bin/bbstored/bbstored', 'bin/bbstored/bbstored-certs', 'bin/bbstored/bbstored-config', 'lib/raidfile/raidfile-config'
      man5.install 'docs/man/bbstored.conf.5.gz', 'docs/man/raidfile.conf.5.gz'
      man8.install 'docs/man/bbstored.8.gz', 'docs/man/bbstoreaccounts.8.gz', 'docs/man/bbstored-certs.8.gz', 'docs/man/bbstored-config.8.gz', 'docs/man/raidfile-config.8.gz'
      mkdir_p "#{etc}/boxbackup/bbstored"
      chmod 0700, "#{etc}/boxbackup/bbstored"
      (prefix+'homebrew.mxcl.boxbackup.bbstored.plist').write plist_server
      (prefix+'homebrew.mxcl.boxbackup.bbstored.plist').chmod 0644
    end

  end

  def test
    if !build.include? 'no-server'
      system "#{sbin}/bbstored", "--version"
    end

    if !build.include? 'no-client'
      system "#{sbin}/bbackupd", "--version"
    end
  end

  def caveats
    server = <<-EOS.undent

      Boxbackup Server (bbstored):
      ----------------------------
      Please see http://www.boxbackup.org/server.html for server configuration.

      To have launchd start bbstored at login:
          ln -sfv #{prefix}/homebrew.mxcl.#{name}.bbstored.plist ~/Library/LaunchAgents
      Then to load bbstored:
          launchctl load ~/Library/LaunchAgents/homebrew.mxcl.#{name}.bbstored.plist
      EOS


    client = <<-EOS.undent

      Boxbackup client (bbackupd):
      ----------------------------
      Please see http://www.boxbackup.org/client.html for client configuration.
      EOS

    msg = ""

    if !build.include? 'no-server'
      msg += server
    end

    if !build.include? 'no-client'
      msg += client
    end

    return msg

  end

  # Override Formula#plist_name
  def plist_name(extra = nil)
    (extra) ? super()+'-'+extra : super()+'.bbackupd'
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    (extra) ? super().dirname+(plist_name(extra)+'.plist') : super()
  end

  def plist
    <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/bbackupd</string>
          <string>-F</string>
          <string>#{etc}/#{name}/bbackupd.conf</string>
        </array>
        <key>LowPriorityIO</key>
        <true/>
        <key>Nice</key>
        <integer>1</integer>
      </dict>
    </plist>
    EOS
  end

  def plist_server
    <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>homebrew.mxcl.#{name}.bbstored</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/bbstored</string>
          <string>-F</string>
          <string>#{etc}/#{name}/bbstored.conf</string>
        </array>
        <key>LowPriorityIO</key>
        <true/>
        <key>Nice</key>
        <integer>1</integer>
      </dict>
    </plist>
    EOS
  end

end
