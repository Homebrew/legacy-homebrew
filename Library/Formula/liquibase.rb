class Liquibase < Formula
  homepage "http://liquibase.org"
  url "https://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.3.1-bin.tar.gz"
  sha1 "4176e2f856ad23f6848a7874a0e855c9f9a00f0e"

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
