require 'formula'

class Grails < Formula
  homepage 'http://grails.org'
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.4.0.zip'
  sha1 '8c92b7fc18540c34e266eace5a1e036fd3783efd'

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
