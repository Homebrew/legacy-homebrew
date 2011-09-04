require 'formula'

class Liquibase < Formula
  url 'http://liquibase.org/liquibase-2.0.1-bin.tar.gz'
  homepage 'http://liquibase.org'
  md5 '5dcceb7b3b5d39c4c39479fce6da2270'

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
