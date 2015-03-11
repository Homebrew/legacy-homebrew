class Denominator < Formula
  homepage "https://github.com/Netflix/denominator/tree/v4.4.1/cli"
  url "https://bintray.com/artifact/download/netflixoss/maven/com/netflix/denominator/denominator-cli/4.4.1/denominator-cli-4.4.1-fat.jar"
  sha1 "57181cd940a845290cf7cfc206b5ec2c08accae3"

  def install
    bin.install "denominator-cli-4.4.1-fat.jar" => "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
