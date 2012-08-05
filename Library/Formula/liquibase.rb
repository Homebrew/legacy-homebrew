require 'formula'

class Liquibase < Formula
  homepage 'http://liquibase.org'
  url 'https://github.com/downloads/liquibase/liquibase/liquibase-2.0.5-bin.tar.gz'
  md5 '350a583a583c06da0d19b3c0bad374db'

  def install
    rm_f Dir['*.bat']

    chmod 0755, Dir['liquibase']

    prefix.install "LICENSE.txt"
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
