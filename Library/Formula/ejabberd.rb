require "formula"

class Ejabberd < Formula
  homepage "http://www.ejabberd.im"
  url "http://www.process-one.net/downloads/ejabberd/14.05/ejabberd-14.05.tgz"
  sha1 "bad6b91ca6b9ac30ffe8b2eb0c5bb759d7742fab"

  depends_on "openssl"
  depends_on "erlang"
  depends_on "libyaml"

  option "32-bit"
  option "with-odbc", "Build with ODBC support"
  option "with-pgsql", "Build with PostgreSQL support"
  option "with-mysql", "Build with MySQL support"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch #{Hardware::CPU.arch_64_bit}"
        ENV.append compiler_flag, "-arch #{Hardware::CPU.arch_32_bit}"
      end
    end

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}"]

    args << "--enable-odbc" if build.with? "odbc"
    args << "--enable-pgsql" if build.with? "pgsql"
    args << "--enable-mysql" if build.with? "mysql"

    system "./configure", *args
    system "make"
    system "make", "install"

    (etc+"ejabberd").mkpath
    (var+"lib/ejabberd").mkpath
    (var+"spool/ejabberd").mkpath
  end

  def caveats; <<-EOS.undent
    If you face nodedown problems, concat your machine name to:
      /private/etc/hosts
    after 'localhost'.
    EOS
  end

  plist_options :manual => "ejabberd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ejabberdctl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
