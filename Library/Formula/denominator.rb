class Denominator < Formula
  desc "Portable Java library for manipulating DNS clouds"
  homepage "https://github.com/Netflix/denominator/tree/v4.7.1/cli"
  url "https://bintray.com/artifact/download/netflixoss/maven/com/netflix/denominator/denominator-cli/4.7.1/denominator-cli-4.7.1-fat.jar"
  version "4.7.1"
  sha256 "f2d09aaebb63ccb348dcba3a5cc3e94a42b0eae49e90ac0ec2b0a14adfbe5254"

  bottle :unneeded

  def install
    bin.install "denominator-cli-4.7.1-fat.jar" => "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
