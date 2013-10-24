require 'formula'

class Pow < Formula
  homepage 'http://pow.cx/'
  url 'http://get.pow.cx/versions/0.4.1.tar.gz'
  sha1 '46976c6eea914ec78ba424b919e8928e4fc9a6bf'

  depends_on 'node'

  def install
    libexec.install Dir['*']
    (bin/'pow').write <<-EOS.undent
      #!/bin/sh
      export POW_BIN="#{HOMEBREW_PREFIX}/bin/pow"
      exec "#{HOMEBREW_PREFIX}/bin/node" "#{libexec}/lib/command.js" "$@"
    EOS
  end

  def caveats;
    <<-EOS.undent
      Sets up firewall rules to forward port 80 to Pow:
        sudo pow --install-system

      Installs launchd agent to start on login:
        pow --install-local

      Enables both launchd agents:
        sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
        launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
    EOS
  end
end
