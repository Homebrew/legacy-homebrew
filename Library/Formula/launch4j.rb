require 'formula'

class Launch4j < Formula
  homepage 'http://launch4j.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.1.0-beta2/launch4j-3.1.0-beta2-macosx-x86.tgz'
  sha1 '4a633263539613e63bc0d9c8e14dda234008f960'
  version '3.1.0-beta2'


  def install
    libexec.install 'launch4j', 'launch4j.jar', 'LICENSE.txt', Dir['bin'], Dir['demo'], Dir['head'], Dir['lib'], Dir['manifest'], Dir['sign4j'], Dir['w32api']
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--help"
  end
end
