require 'formula'

class Liquibase < Formula
  homepage 'http://liquibase.org'
  url 'http://downloads.sourceforge.net/project/liquibase/Liquibase%20Core/liquibase-3.0.6-bin.tar.gz'
  sha1 '82e26da2dd866cd47a849cddc3c643c485ea3764'

  def install
    rm_f Dir['*.bat']

    chmod 0755, Dir['liquibase']

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink libexec+'liquibase'
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
