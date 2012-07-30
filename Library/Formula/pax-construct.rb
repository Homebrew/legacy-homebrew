require 'formula'

class PaxConstruct < Formula
  homepage 'http://wiki.ops4j.org/display/paxconstruct/Pax+Construct'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/construct/scripts/1.5/scripts-1.5.zip'
  sha1 'af7bf6d6ab4947e1b38a33e89fb1d2dbfe4ad864'

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
