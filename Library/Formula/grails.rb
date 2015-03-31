require 'formula'

class Grails < Formula
  homepage 'http://grails.org'
  url 'https://github.com/grails/grails-core/releases/download/v2.5.0/grails-2.5.0.zip'
  sha1 '3415b14440eb3fb0de7fb39964fc3d5a4d3ee0f9'

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The GRAILS_HOME directory is:
      #{opt_libexec}
    EOS
  end
end
