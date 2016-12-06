class Metabase < Formula
  desc "Business intelligence report server"
  homepage "http://www.metabase.com/"
  url "http://downloads.metabase.com/v0.13.0/metabase.jar"
  version "0.13.0"
  sha256 "d14c3a5daf543a362b14ee0215bdabcad40e23be7aa46f25986d67c62e5e5b07"

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "node" => :build
    depends_on "leiningen" => :build
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    if build.head?
      ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end
    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  plist_options :startup => true, :manual => "metabase"

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
        <string>#{opt_bin}/metabase</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/metabase</string>
      <key>StandardOutPath</key>
      <string>#{var}/metabase/server.log</string>
      <key>StandardErrorPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
