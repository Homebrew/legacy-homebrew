require 'formula'

class Pgbouncer < Formula
  homepage 'http://wiki.postgresql.org/wiki/PgBouncer'
  url 'http://pgfoundry.org/frs/download.php/3393/pgbouncer-1.5.4.tar.gz'
  sha1 '87c3dd7fc70cbbae93ce8865953891f0aabffd2d'

  depends_on 'asciidoc' => :build
  depends_on 'xmlto' => :build
  depends_on 'libevent'

  def install
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    ln_s "../install-sh", "doc/install-sh"
    system "make install"
    bin.install "etc/mkauth.py"
    etc.install %w(etc/pgbouncer.ini etc/userlist.txt)
  end

  def caveats; <<-EOS.undent
    The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
    will need to edit it for your particular setup. See:
    http://pgbouncer.projects.postgresql.org/doc/config.html

    The auth_file option should point to the #{etc}/userlist.txt file which
    can be populated by the #{bin}/mkauth.py script.
    EOS
  end

  plist_options :manual => "pgbouncer -q #{HOMEBREW_PREFIX}/etc/pgbouncer.ini"

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pgbouncer</string>
          <string>-d</string>
          <string>-q</string>
          <string>#{etc}/pgbouncer.ini</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end
end
