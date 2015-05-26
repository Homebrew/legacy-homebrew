require 'formula'

class Apktool < Formula
  homepage 'https://github.com/iBotPeaches/Apktool'
  url 'https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.0.jar', :using => :nounzip
  sha1 '577e351e5b06986c7e099ec33944934f3b9e31e1'

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", 'apktool'
  end
end
