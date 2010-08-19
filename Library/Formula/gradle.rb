require 'formula'

class Gradle <Formula
  url 'http://dist.codehaus.org/gradle/gradle-0.8-all.zip'
  homepage 'http://www.gradle.org/'
  version '0.8'
  md5 '73a0ed51b6ec00a7d3a9d242d51aae60'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib gradle-imports plugin.properties]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
