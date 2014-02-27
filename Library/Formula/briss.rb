require 'formula'

class Briss < Formula
  homepage 'http://briss.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/briss/release%200.9/briss-0.9.tar.gz'
  sha1 'ecdcd1dd73d93d00f9b66a6ac9c948518c21a5ed'

  def install
    libexec.install Dir['*.jar']
    bin.write_jar_script libexec/"briss-#{version}.jar", "briss"
  end
end
