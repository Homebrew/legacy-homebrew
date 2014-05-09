require "formula"

class Perp < Formula
  homepage "http://b0llix.net/perp/"
  url "http://b0llix.net/perp/distfiles/perp-2.07.tar.gz"
  sha1 "2d2f24fc45a405876f101701ab8059f5ac7ad07a"

  def install
    inreplace 'conf.mk', 'CC = gcc', 'CC = cc'
    inreplace 'conf.mk', 'BINDIR = /usr/bin', "BINDIR = #{bin}"
    inreplace 'conf.mk', 'SBINDIR = /usr/sbin', "SBINDIR = #{sbin}"
    inreplace 'conf.mk', 'MANDIR  = /usr/share/man', "MANDIR = #{man}"

    system "make"
    system "make", "strip"
    system "make", "install"
  end

  def post_install
    (etc/"perp").mkpath
    (var/"run/perp").mkpath
    ENV['NO_INIT'] = "1"
    system "#{sbin}/perp-setup #{perp_base}"
    system "ln -fs #{working_dir} #{perp_base}/.control"

    (Pathname.new "rc.log").atomic_write rc_dot_log
    (etc/"perp/.boot").install "rc.log"

    (Pathname.new "rc.perp").atomic_write rc_dot_perp
    (etc/"perp/.boot").install "rc.perp"
  end

  def test
    (Pathname.new 'argfile').atomic_write <<-EOS.undent
      foo
      bar
      baz
    EOS

    "foo bar baz\n" == `#{sbin}/runargs argfile echo`
  end

  def rc_dot_log; <<-EOS.undent
    #!/bin/sh
    LOGDIR=#{var}/log/perpd
    exec tinylog -k 8 -s 100000 -t ${LOGDIR}
    EOS
  end

  def rc_dot_perp; <<-EOS.undent
    #!/bin/sh
    exec perpd -a 6 $PERP_BASE
    EOS
  end

  def perp_base
    etc/"perp"
  end

  def working_dir
    var/"run/perp"
  end

  def caveats; <<-EOS.undent
    You ought to set PERP_PASE to a perp operating directory

    for the default:
    % export PERP_BASE=#{perp_base}
    EOS
  end

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
          <string>#{opt_sbin}/perpboot</string>
          <string>#{perp_base}</string>
        </array>

        <key>RunAtLoad</key>
        <true/>

        <key>WorkingDirectory</key>
        <string>#{working_dir}</string>

        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin</string>
        </dict>
      </dict>
    </plist>
    EOS
  end

end
