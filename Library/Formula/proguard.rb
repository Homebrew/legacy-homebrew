require 'formula'

class Proguard < Formula
  homepage 'http://proguard.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/proguard/proguard/4.11/proguard4.11.tar.gz'
  sha256 '90a4dbf8c016fd84da6d48d8b16e450ee07abafbfb7bb6eb5028651a8c255d9e'

  def install
    libexec.install 'lib/proguard.jar'
    bin.write_jar_script libexec/'proguard.jar', 'proguard'
  end
end
