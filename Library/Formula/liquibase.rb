require "formula"

class Liquibase < Formula
  homepage "http://liquibase.org"
  url "https://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.2.0-bin.tar.gz"
  sha1 "155b4c9cf9a434bbe98a7a48b9acd46eb6d77f0a"

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
