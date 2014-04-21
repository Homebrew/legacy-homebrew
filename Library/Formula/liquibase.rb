require 'formula'

class Liquibase < Formula
  homepage 'http://liquibase.org'
  url 'https://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.1.1-bin.tar.gz'
  sha1 '48af02bd837eab401236963c5868fc4dae5dfbee'

  def install
    rm_f Dir['*.bat']

    chmod 0755, Dir['liquibase']

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink libexec+'liquibase'
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable LIQUIBASE_HOME to
        #{libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
