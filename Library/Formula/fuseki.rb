require 'formula'

class Fuseki < Formula
  desc "SPARQL server"
  homepage 'https://jena.apache.org/documentation/fuseki2/index.html'
  url 'https://www.apache.org/dist/jena/binaries/apache-jena-fuseki-2.3.0.tar.gz'
  sha256 'b37a81d7b4455ccc07055e50dc13c482c9e2a729e329eec6d2d5d51fc2e724ee'

  def install
    # Remove windows files
    rm_f 'fuseki-server.bat'

    # Remove init.d script to avoid confusion
    rm 'fuseki'

    # Write the installation path into the wrapper shell script
    inreplace 'fuseki-server' do |s|
      s.gsub! /export FUSEKI_HOME=.+/,
              %'export FUSEKI_HOME="#{libexec}"'
    end

    # Install and symlink wrapper binaries into place
    libexec.install 'fuseki-server'
    bins = ['bin/s-delete', 'bin/s-get', 'bin/s-head', 'bin/s-post', 'bin/s-put', 'bin/s-query', 'bin/s-update', 'bin/s-update-form', 'bin/soh']
    chmod 0755, bins
    libexec.install bins
    bin.install_symlink Dir["#{libexec}/*"]
    # Non-symlinked binaries and application files
    libexec.install 'fuseki-server.jar', 'webapp'

    # Create a location for dataset and log files,
    # in case we're being used in LaunchAgent mode
    (var/'fuseki').mkpath
    (var/'log/fuseki').mkpath

    # Install documentation
    prefix.install 'LICENSE', 'NOTICE'
  end

  def caveats; <<-EOS.undent
    Quick-start guide:

    * See the Fuseki documentation for instructions on running Fuseki from the command line:
      https://jena.apache.org/documentation/fuseki2/fuseki-run.html#fuseki-as-a-standalone-server

    * You may want to set the FUSEKI_BASE environment variable which points to the runtime area
      for the server instance (defaults to 'run/' of the current directory).

      For example, set FUSEKI_BASE=/tmp/fuseki to avoid polluting your hard disk with 'run/' folders.
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>EnvironmentVariables</key>
        <dict>
           <key>FUSEKI_BASE</key>
           <string>#{var}/fuseki</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/fuseki-server</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/fuseki.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/fuseki.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/fuseki-server", '--version'
  end
end
