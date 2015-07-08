class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.0/liquibase-3.4.0-bin.tar.gz"
  sha1 "f2747762de5dce1876bbd4f6b9c9e00e97de7f97"

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
