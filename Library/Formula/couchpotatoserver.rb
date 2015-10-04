class Couchpotatoserver < Formula
  desc "Download movies automatically"
  homepage "https://couchpota.to"
  url "https://github.com/RuudBurger/CouchPotatoServer/archive/build/2.6.3.tar.gz"
  sha256 "8735adc2c518fb517da916f4e9554dcfbba67d2e640b24fc7acdfa7baa0c78fc"

  head "https://github.com/RuudBurger/CouchPotatoServer.git"

  bottle do
    cellar :any
    sha256 "060521cab660a6fb15265e8239d9685dc9034a65100f1960b5249b8a84a563af" => :yosemite
    sha256 "b2c7bbcd61a338c4b35cebc76a393c3564d7b5dc35c494df3ecda65c88d174d9" => :mavericks
    sha256 "f2ea47a3082dce305db9efd82001a5a7479475abfe1ce1efd7332ebcbc29f145" => :mountain_lion
  end

  def install
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin+"couchpotatoserver").write(startup_script)
  end

  plist_options :manual => "couchpotatoserver"

  def plist; <<-EOS.undent
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/couchpotatoserver</string>
        <key>ProgramArguments</key>
        <array>
          <string>--quiet</string>
          <string>--daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
      </dict>
    </plist>
    EOS
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    python "#{libexec}/CouchPotato.py"\
           "--pid_file=#{var}/run/couchpotatoserver.pid"\
           "--data_dir=#{etc}/couchpotatoserver"\
           "$@"
    EOS
  end

  def caveats
    "CouchPotatoServer defaults to port 5050."
  end

  test do
    system "#{bin}/couchpotatoserver", "--help"
  end
end
