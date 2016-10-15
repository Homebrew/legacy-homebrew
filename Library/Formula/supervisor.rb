class Supervisor < Formula
  homepage "http://supervisord.org/"
  url "https://pypi.python.org/packages/source/s/supervisor/supervisor-3.1.3.tar.gz"
  sha256 "e32c546fe8d2a6e079ec4819c49fd24534d4075a58af39118d04367918b3c282"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz"
    sha256 "718d13adf87f99a45835bb20e0a1c4c036de644cd32b3f112639403aa04ebeb5"
  end

  resource "meld3" do
    url "https://pypi.python.org/packages/source/m/meld3/meld3-1.0.2.tar.gz"
    sha256 "f7b754a0fde7a4429b2ebe49409db240b5699385a572501bb0d5627d299f9558"
  end

  resource "elementree" do
    url "http://effbot.org/media/downloads/elementtree-1.2.6-20050316.tar.gz"
    sha256 "b29d5f2417cb331562c8c5f8ebef2a895ba540261c4245f526143c6a31bccb04"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    touch libexec/"lib/python2.7/site-packages/supervisor/__init__.py"
    bin.install Dir[libexec/"bin/supervisor*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    (prefix/"supervisord.conf").write supervisord_conf
  end

  def post_install
    (etc/"supervisord/conf.d").mkpath unless File.directory? etc/"supervisord/conf.d"
    cp prefix+"supervisord.conf", etc unless File.exist? etc/"supervisord.conf"
  end

  def caveats; <<-EOS.undent
    The supervisorctl command will need to be run with the full path to the conf file:
        supervisorctl -c #{etc}/supervisord.conf
    You can alias the command in your shell to make it easier:
        alias supervisorctl='supervisorctl -c #{etc}/supervisord.conf'
    or with root access link the config to /etc:
        ln -s #{etc}/supervisord.conf /etc/supervisord.conf

    Add your supervisor program config to: (http://supervisord.org/subprocess.html)
        #{etc}/supervisord/conf.d/
    EOS
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/supervisord --version"))
    assert_match(/\nOptions:/, shell_output("#{bin}/supervisorctl --help"))
  end

  def supervisord_conf; <<-EOS.undent
    [unix_http_server]
    file=#{var}/run/supervisor.sock
    chmod       = 0700
    ;username    = admin
    ;password    = somepass

    ;[inet_http_server]
    ;port        = 127.0.0.1:9001
    ;username    = admin
    ;password    = somepass

    [supervisord]
    logfile     = #{var}/log/supervisord.log
    logfile_maxbytes = 50MB
    logfile_backups = 10
    loglevel    = info
    pidfile     = #{var}/run/supervisord.pid
    nodaemon    = false
    minfds      = 1024
    minprocs    = 200
    umask       = 022
    identifier   = supervisor
    ;directory   = #{var}/run
    ;nocleanup   = true
    ;childlogdir = #{var}/log

    [supervisorctl]
    serverurl   = unix://#{var}/run/supervisor.sock
    ;serverurl   = http://127.0.0.1:9001
    ;username    = admin
    ;password    = somepass

    [rpcinterface:supervisor]
    supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

    [include]
    files = #{etc}/supervisord/conf.d/*.conf
    EOS
  end

  # vars don't seem to be available here
  plist_options :manual => "supervisord -c #{HOMEBREW_PREFIX}/etc/supervisord.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/supervisord</string>
            <string>-n</string>
            <string>-c</string>
            <string>#{etc}/supervisord.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{prefix}</string>
    </dict>
    </plist>
    EOS
  end
end
