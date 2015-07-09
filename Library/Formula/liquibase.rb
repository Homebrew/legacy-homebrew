class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.0/liquibase-3.4.0-bin.tar.gz"
  sha256 "c3c6869b3f36433f3a1f9c49890047100594b57ed54183f686e7421a43567f03"

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
