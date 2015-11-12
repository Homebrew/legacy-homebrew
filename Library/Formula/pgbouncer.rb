class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://wiki.postgresql.org/wiki/PgBouncer"
  url "https://pgbouncer.github.io/downloads/files/1.6.1/pgbouncer-1.6.1.tar.gz"
  mirror "https://github.com/pgbouncer/pgbouncer/archive/pgbouncer_1_6_1.tar.gz"
  sha256 "40ff5cd84399b4da3ba864ad654fe155a0ed085261e68f3e31b1117812b17056"

  bottle do
    cellar :any
    sha256 "f4002665b424ad1a17fbeb6823b9ebc5dcb7ba1e46b508275de9ffdea9bf05f1" => :el_capitan
    sha256 "d74eb1920c6b93d10f9143e89170a57850a1e07b95988dc84216951d8ebf70dd" => :yosemite
    sha256 "041022098c72050bbeea9b3af992287e24453e590b549bb81c396cfff2b7f5c7" => :mavericks
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "libevent"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    ln_s "../install-sh", "doc/install-sh"
    system "make", "install"
    bin.install "etc/mkauth.py"
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
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

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end
