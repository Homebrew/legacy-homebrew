require "formula"

class Liquibase < Formula
  homepage "http://liquibase.org"
  url "https://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.3.0-bin.tar.gz"
  sha1 "00aaa2e658f173e5b15a9edb61e8904a75b07955"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink libexec+"liquibase"
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
