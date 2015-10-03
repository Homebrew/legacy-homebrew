class Briss < Formula
  desc "Crop PDF files"
  homepage "http://briss.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/briss/release%200.9/briss-0.9.tar.gz"
  sha256 "45dd668a9ceb9cd59529a9fefe422a002ee1554a61be07e6fc8b3baf33d733d9"

  def install
    libexec.install Dir["*.jar"]
    bin.write_jar_script libexec/"briss-#{version}.jar", "briss"
  end
end
