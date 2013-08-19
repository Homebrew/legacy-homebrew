require 'formula'

class Proguard < Formula
  homepage 'http://proguard.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/proguard/proguard/4.10/proguard4.10.tar.gz'
  sha256 'a8ef5a95ae0c41c0a1a2aae5daa70c4c376fa49a9318a6d776aed2fcd76e8f4d'

  def install
    libexec.install 'lib/proguard.jar'
    bin.write_jar_script libexec/'proguard.jar', 'proguard'
  end
end
