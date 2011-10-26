require 'formula'

class Liquibase < Formula
  url 'https://github.com/downloads/liquibase/liquibase/liquibase-2.0.3-bin.tar.gz'
  homepage 'http://liquibase.org'
  md5 '460a4bba1fd6a9c4bd44016f3af9728d'

  def install
    rm_f Dir['*.bat']

    chmod 0755, Dir['liquibase']

    prefix.install "LICENSE.txt"
    libexec.install Dir['*']

    bin.mkpath
    ln_s libexec+('liquibase'), bin
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable LIQUIBASE_HOME to
        #{libexec}
    EOS
  end
end
