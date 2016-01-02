class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.2/liquibase-3.4.2-bin.tar.gz"
  sha256 "c52f6c795169073158a30ee528b1f566ba57bb56e242cac2aa175789bec47dcf"

  bottle :unneeded

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
