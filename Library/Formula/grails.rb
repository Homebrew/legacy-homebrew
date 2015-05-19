require 'formula'

class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage 'https://grails.org'
  url 'https://github.com/grails/grails-core/releases/download/v3.0.1/grails-3.0.1.zip'
  sha256 'c58da97ad7fb9635c6fb5631755501b97d6ce9ee6668dc12f0722928ffa5abee'

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
