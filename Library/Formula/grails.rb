require 'formula'

class Grails < Formula
  homepage 'https://grails.org'
  url 'https://github.com/grails/grails-core/releases/download/v3.0.0/grails-3.0.0.zip'
  sha256 '28b8288c1062e6f42dd43f19f4bbde62604a968f65068b4b77f9e5178db3bb3c'

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
