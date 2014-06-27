require 'formula'

class Grails < Formula
  homepage 'http://grails.org'
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.4.2.zip'
  sha1 '7ca880423826f5714a0fefe1343990bff0057df5'

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
