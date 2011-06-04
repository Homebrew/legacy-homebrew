require 'formula'

class PaxConstruct < Formula
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/construct/scripts/1.4/scripts-1.4.zip'
  homepage 'http://wiki.ops4j.org/display/paxconstruct/Pax+Construct'
  md5 '069b00a8073ca76b42d7b743c09d577f'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.bat']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin
      chmod 0755, (bin + File.basename(f))
    end
  end
end
