require 'formula'

class Pow < Formula
  url 'http://get.pow.cx/versions/0.4.0.tar.gz'
  homepage 'http://pow.cx/'
  md5 'bbb139a4f1142c760eb0d5a8cfa3f7d6'

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
