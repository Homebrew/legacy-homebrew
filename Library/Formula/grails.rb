require 'formula'

class Grails < Formula
  homepage 'http://grails.org'
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.2.1.zip'
  sha1 '34d5c7d13dc92ef35f726e949d03164f69e23962'

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install_metafiles
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
