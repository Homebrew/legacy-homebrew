class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.1/liquibase-3.4.1-bin.tar.gz"
  sha256 "693919918e217e7a88c5140e82f279f31f636233a62cd2108abdafa4f3ed0a02"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink libexec/"liquibase"
  end

  def caveats; <<-EOS.undent
    You should set the environment variable LIQUIBASE_HOME to
      #{libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
