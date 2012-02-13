require 'formula'

class Grails < Formula
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.0.0.zip'
  homepage 'http://grails.org'
  md5 '9d18e2b3bbb4ed249ff1fad1f4b11311'

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install %w[LICENSE README]
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end

  def caveats
    <<-EOS.undent
    IMPORTANT!

    Notes On Upgrading #{name.capitalize} From Versions < 1.3.7

    The directory layout has been changed slightly for versions >= 1.3.7
    in order to conform with Homebrew conventions for installation of Java
    jar files.  Please note the following:

    Before upgrading -

      run 'brew unlink #{name}' (keeps old version in cellar)
      OR
      run 'brew rm #{name}' (deletes old version from cellar)
      THEN
      run 'brew prune'

    This is to ensure that #{HOMEBREW_PREFIX} is cleaned of references to the
    old version.

    The #{name.capitalize} home directory for versions < 1.3.7 was in the form:

      #{HOMEBREW_CELLAR}/#{name}/1.3.6

    For versions >= 1.3.7, the #{name.capitalize} home directory is in the form:

      #{libexec}

    If you set the GRAILS_HOME variable explicitly in your shell environment,
    change its value accordingly.
    EOS
  end

end
