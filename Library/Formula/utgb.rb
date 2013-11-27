require 'formula'

class Utgb < Formula
  homepage 'http://utgenome.org/'
  url 'http://maven.utgenome.org/repository/artifact/org/utgenome/utgb-shell/1.5.9/utgb-shell-1.5.9-bin.tar.gz'
  sha1 'fe4aaccfca40df85c495073385f1a5ff904ac893'
  version '1.5.9'

  def install
     bin.install Dir['bin/utgb']
     bin.install Dir['bin/*.conf']
     prefix.install Dir['boot']
     prefix.install Dir['lib']
     bin.install_symlink Dir['bin/utgb']
  end

  def test
    system "#{bin}/utgb"
  end
end
