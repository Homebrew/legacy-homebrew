require 'formula'

class Groovy <Formula
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.5.zip'
  md5 '77538791a644bb3129662dbf5db006a4'
  homepage 'http://groovy.codehaus.org/'

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install %w{ LICENSE.txt NOTICE.txt }
    libexec.install %w[bin conf lib]

    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end
end
