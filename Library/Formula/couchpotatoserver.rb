class Couchpotatoserver < Formula
  desc "Download movies automatically"
  homepage "https://couchpota.to"
  url "https://github.com/RuudBurger/CouchPotatoServer/archive/build/3.0.1.tar.gz"
  sha256 "f08f9c6ac02f66c6667f17ded1eea4c051a62bbcbadd2a8673394019878e92f7"

  head "https://github.com/RuudBurger/CouchPotatoServer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "105d05597386086c63876f758bb19338b1c6e6f254457a84725abb51a9c6cf6a" => :el_capitan
    sha256 "e1460a9cde522adfd0e166b8e38e0aa0e53767fbfa728f4249062645c7fa77d7" => :yosemite
    sha256 "1724acd1b5a316f11da63705af4c840d298326ed3be693d3339115cad957fbf7" => :mavericks
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
