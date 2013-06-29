require 'formula'

class Proguard < Formula
  homepage 'http://proguard.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/proguard/proguard/4.9/proguard4.9.tar.gz'
  sha256 '3c8e9a6aee1d965c19d4b426596db9983fb3bff0f589bbc527973c310767d348'

  def install
    libexec.install 'lib/proguard.jar'
    bin.write_jar_script libexec/'proguard.jar', 'proguard'
  end
end
