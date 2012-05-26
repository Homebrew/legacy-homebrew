require 'formula'

class Grails < Formula
  homepage 'http://grails.org'
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.0.4.zip'
  md5 '91fa37b7425b2a58ad9a69667418c73a'

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install %w[LICENSE README]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Notes On Upgrading Grails From Versions < 1.3.7

    The directory layout has been changed slightly for versions >= 1.3.7
    in order to conform with Homebrew conventions for installation of Java
    jar files.  Please note the following:

    Before upgrading:
      run 'brew unlink grails' (keeps old version in cellar)
    or
      run 'brew rm grails' (deletes old version from cellar)

    and then:
      run 'brew prune'

    This is to ensure that HOMEBREW_PREFIX is cleaned of references to the
    old version.

    The Grails home directory for versions < 1.3.7 was in the form:
      #{HOMEBREW_CELLAR}/grails/1.3.6

    For versions >= 1.3.7, the Grails home directory is in the form:
      #{libexec}

    If you set the GRAILS_HOME variable explicitly in your shell environment,
    change its value accordingly.
    EOS
  end
end
