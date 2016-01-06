class CouchdbLucene < Formula
  desc "Full-text search of CouchDB documents using Lucene"
  homepage "https://github.com/rnewson/couchdb-lucene"
  url "https://github.com/rnewson/couchdb-lucene/archive/v1.0.2.tar.gz"
  sha256 "c3f33890670160b14515fd1e26aa30df89f6101f36148639f213c40a6fff8e7d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "38f8b7946415fadd1ed0d0bae55a2b4a07b887b68a6513436bb33347fe25b59f" => :el_capitan
    sha256 "9da083783bddfdff05e89511006eddc7a4e382b04b897741a7418f48f6b6dff0" => :yosemite
    sha256 "41fdbc137d3a24139de0fd0ae4111ae7d6f14d20fb9aaba25b5ef0b5bb21085d" => :mavericks
  end

  depends_on "couchdb"
  depends_on "maven" => :build
  depends_on :java

  def install
    ENV.java_cache

    system "mvn"
    system "tar", "-xzf", "target/couchdb-lucene-#{version}-dist.tar.gz", "--strip", "1"

    prefix.install_metafiles
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      cmd = "cl_#{bin_name}"
      (bin/cmd).write shim_script(bin_name)
      (libexec/"clbin").install_symlink bin/cmd => bin_name
    end

    ini_path.write(ini_file) unless ini_path.exist?
  end

  def shim_script(target); <<-EOS.undent
    #!/bin/bash
    export CL_BASEDIR=#{libexec}/bin
    exec "$CL_BASEDIR/#{target}" "$@"
    EOS
  end

  def ini_path
    etc/"couchdb/local.d/couchdb-lucene.ini"
  end

  def ini_file; <<-EOS.undent
    [httpd_global_handlers]
    _fti = {couch_httpd_proxy, handle_proxy_req, <<"http://127.0.0.1:5985">>}
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/couchdb-lucene/bin/cl_run"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>HOME</key>
          <string>~</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cl_run</string>
        </array>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'cl_'.

    If you really need to use these commands with their normal names, you
    can add a "clbin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/clbin:$PATH"
    EOS
  end

  test do
    # This seems to be the easiest way to make the test play nicely in our
    # sandbox. If it works here, it'll work in the normal location though.
    cp_r Dir[opt_prefix/"*"], testpath
    inreplace "bin/cl_run", "CL_BASEDIR=#{libexec}/bin",
                            "CL_BASEDIR=#{testpath}/libexec/bin"

    io = IO.popen("#{testpath}/bin/cl_run")
    sleep 2
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    io.read !~ /Exception/
  end
end
