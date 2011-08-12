require 'formula'

class Pow < Formula
  url 'http://get.pow.cx/versions/0.3.1.tar.gz'
  homepage 'http://pow.cx/'
  md5 '2eff3e7a048aada38a85cad5e73a936a'

  depends_on 'node'

  def install
    (prefix+'pow').install Dir['*']

    bin.mkdir
    File.open("#{bin}/pow", 'w') do |f|
      f.write <<-EOS.undent
        #!/bin/sh
        export POW_BIN="#{HOMEBREW_PREFIX}/bin/pow"
        exec "#{HOMEBREW_PREFIX}/bin/node" "#{prefix}/pow/lib/command.js" "$@"
      EOS
    end
    system "chmod +x #{bin}/pow"
  end

  def caveats;
    <<-EOS.undent
      Sets up firewall rules to forward port 80 to Pow:
        sudo pow --install-system

      Installs launchd agent to start on login:
        pow --install-local

    EOS
  end
end
