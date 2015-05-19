class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.3.2-bin.tar.gz"
  sha1 "89ddda7d5ca8d38947bfee0d4aa58534d943b990"

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
