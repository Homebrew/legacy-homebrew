require "formula"

class Pow < Formula
  desc "Zero-config Rack server for local apps on OS X"
  homepage "http://pow.cx/"
  url "http://get.pow.cx/versions/0.5.0.tar.gz"
  sha1 "ef44f886a444340b91fb28e2fab3ce5471837a08"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"pow").write <<-EOS.undent
      #!/bin/sh
      export POW_BIN="#{bin}/pow"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/command.js" "$@"
    EOS
  end

  def caveats;
    <<-EOS.undent
      Create the required host directories:
        mkdir -p ~/Library/Application\\ Support/Pow/Hosts
        ln -s ~/Library/Application\\ Support/Pow/Hosts ~/.pow

      Setup port 80 forwarding and launchd agents:
        sudo pow --install-system
        pow --install-local

      Load launchd agents:
        sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
        launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
    EOS
  end
end
