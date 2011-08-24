require 'formula'

class Liquibase < Formula
  url 'http://liquibase.org/liquibase-2.0.1-bin.tar.gz'
  homepage 'http://www.liquibase.org/'
  md5 '5dcceb7b3b5d39c4c39479fce6da2270'

  skip_clean :all

  def install
    # Remove Windows scripts
    rm_rf Dir['*.bat']
    File.chmod 0755, 'liquibase'
    # Install files
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    ln_s "#{libexec}/liquibase", bin + "liquibase"
  end
end
