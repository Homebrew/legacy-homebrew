require 'formula'

class Liquibase < Formula
  homepage 'http://liquibase.org'
  url 'http://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.0.1-bin.tar.gz'
  sha1 'a84ee01dc3987d8a710b56baca8e6ebe2e837c75'

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
end
