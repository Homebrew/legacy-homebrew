require 'formula'

class Liquibase < Formula
  homepage 'http://liquibase.org'
  url 'https://github.com/downloads/liquibase/liquibase/liquibase-2.0.5-bin.tar.gz'
  sha1 'eb237c4b9b8c85aff5ddac6272f6291ae593c7a4'

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
