class Supervisor < Formula
  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://github.com/Supervisor/supervisor/archive/3.2.1.tar.gz"
  sha256 "d9c0b17ec42ac6477e7ef0ad2e1f6f1597f855a4d9606c024ac40eb034d6e9ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3c866f998dc05c9cbab8d5b7561e7fe4c14d5f786525b02e50ca78438b1c701" => :el_capitan
    sha256 "752e757102b2040b0e36add68b4e5481bdd511f37b9a8fa61dfa463b3f0c0ed7" => :yosemite
    sha256 "8b5cfa44ab4c77ff668210a0330dce12711c08c18d32c5137cfbe228bf0bc2a1" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "meld3" do
    url "https://pypi.python.org/packages/source/m/meld3/meld3-1.0.2.tar.gz"
    sha256 "f7b754a0fde7a4429b2ebe49409db240b5699385a572501bb0d5627d299f9558"
  end

  def install
    inreplace buildpath/"supervisor/skel/sample.conf" do |s|
      s.gsub! %r{/tmp/supervisor\.sock}, var/"run/supervisor.sock"
      s.gsub! %r{/tmp/supervisord\.log}, var/"log/supervisord.log"
      s.gsub! %r{/tmp/supervisord\.pid}, var/"run/supervisord.pid"
      s.gsub! /^;\[include\]$/, "[include]"
      s.gsub! %r{^;files = relative/directory/\*\.ini$}, "files = #{etc}/supervisor.d/*.ini"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("meld3").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # For an explanation, see https://github.com/Supervisor/supervisor/issues/608.
    touch libexec/"lib/python2.7/site-packages/supervisor/__init__.py"

    etc.install buildpath/"supervisor/skel/sample.conf" => "supervisord.ini"
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

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  test do
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
                   shell_output("#{bin}/supervisorctl --configuration supervisord.ini version"))
    ensure
      Process.kill "TERM", pid
    end
  end
end
