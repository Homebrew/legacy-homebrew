class Luciddb < Formula
  desc "DBMS optimized for business intelligence"
  homepage "http://www.luciddb.org/"
  url "https://downloads.sourceforge.net/project/luciddb/luciddb/luciddb-0.9.4/luciddb-bin-macos32-0.9.4.tar.bz2"
  sha256 "fe6caa93d63a97e412e2bc478e1a1bd99c2aa736b1dcfea665cbab94b8da8593"

  def shim_script(target)
    <<-EOS.undent
      #!/bin/bash
      export JAVA_HOME=`/usr/libexec/java_home`
      exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    cd libexec/"install" do
      # install.sh just sets Java classpaths and writes them to bin/classpath.gen.
      # This is why we run it /after/ copying all the files to #{libexec}.
      ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
      system "./install.sh"
    end
    Dir.glob("#{libexec}/bin/*") do |b|
      next if b =~ /classpath.gen/ || b =~ /defineFarragoRuntime/
      n = File.basename(b)
      (bin+n).write shim_script(n)
    end
  end

  plist_options :manual => "lucidDbServer"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>JAVA_HOME</key>
        <string>#{`/usr/libexec/java_home`.chomp}</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{libexec}/bin/lucidDbServer</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{libexec}</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOS
  end
end
