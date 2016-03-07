class Supervisor < Formula
  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://github.com/Supervisor/supervisor/archive/3.2.1.tar.gz"
  sha256 "d9c0b17ec42ac6477e7ef0ad2e1f6f1597f855a4d9606c024ac40eb034d6e9ed"

  # Although Supervisor itself doesn't require Python 2.7 (its actual lower
  # bound is 2.4) this formula only targets 2.7 for simplicity.
  depends_on :python if MacOS.version <= :snow_leopard

  resource "meld3" do
    url "https://pypi.python.org/packages/source/m/meld3/meld3-1.0.2.tar.gz"
    sha256 "f7b754a0fde7a4429b2ebe49409db240b5699385a572501bb0d5627d299f9558"
  end

  def install
    # Before the example Supervisor configuration file gets installed, modify
    # it to use Homebrew's conventions.
    inreplace buildpath/"supervisor/skel/sample.conf" do |s|
      # A `[unix_http_server]` modification
      s.gsub! %r{(?<=^file=)/tmp/supervisor.sock}, var/"run/supervisor.sock"

      # Some `[supervisord]` modifications
      s.gsub! %r{(?<=^logfile=)/tmp/supervisord.log}, var/"log/supervisord.log"
      s.gsub! %r{(?<=^pidfile=)/tmp/supervisord.pid}, var/"run/supervisord.pid"

      # A `[supervisorctl]` modification
      s.gsub! %r{(?<=serverurl=)unix:///tmp/supervisor.sock}, "unix://#{var}/run/supervisor.sock"

      # An `[include]` modification
      s.gsub! ";files = relative/directory/*.ini",
              "files = #{etc}/supervisor.d/*.ini"
    end

    etc.install buildpath/"supervisor/skel/sample.conf" => "supervisord.ini"

    resource("meld3").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Q.v. <https://github.com/Supervisor/supervisor/issues/608>.
    touch libexec/"lib/python2.7/site-packages/supervisor/__init__.py"
  end

  test do
    # Create a minimal configuration file for supervisord.
    (testpath/"supervisord.ini").write <<-EOS.undent
      [unix_http_server]
      file=supervisor.sock

      [supervisord]
      loglevel=debug

      [rpcinterface:supervisor]
      supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

      [supervisorctl]
      serverurl=unix://supervisor.sock
    EOS

    begin
      pid = fork do
        exec "#{bin}/supervisord", "--configuration", "supervisord.ini",
                                   "--nodaemon"
      end
      sleep 1
      assert_match(version.to_s,
                   shell_output("#{bin}/supervisorctl version --configuration supervisord.ini"))
    ensure
      Process.kill "TERM", pid
    end
  end

  plist_options :manual => "supervisord -c #{HOMEBREW_PREFIX}/etc/supervisord.ini"

  def plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>

          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false />
          </dict>

          <key>Label</key>
          <string>#{plist_name}</string>

          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/supervisord</string>
            <string>--configuration</string>
            <string>#{etc}/supervisord.ini</string>
            <string>--nodaemon</string>
          </array>

        </dict>
      </plist>
    EOS
  end
end
