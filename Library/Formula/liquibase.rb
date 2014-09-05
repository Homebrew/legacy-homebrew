require "formula"

class Liquibase < Formula
  homepage "http://liquibase.org"
  url "https://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.2.2-bin.tar.gz"
  sha1 "7d35f3414253e0e2f81fc5a9d1db8ed9c0673f88"

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
