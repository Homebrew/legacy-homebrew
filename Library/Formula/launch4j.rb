require 'formula'

class Launch4j < Formula
  homepage 'http://launch4j.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.1.0-beta2/launch4j-3.1.0-beta2-macosx-x86.tgz'
  sha1 '4a633263539613e63bc0d9c8e14dda234008f960'
  version '3.1.0-beta2'

  def install
    libexec.install Dir['*'] - ['src', 'web']
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
