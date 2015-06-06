class Denominator < Formula
  desc "Portable Java library for manipulating DNS clouds"
  homepage "https://github.com/Netflix/denominator/tree/v4.5.0/cli"
  url "https://bintray.com/artifact/download/netflixoss/maven/com/netflix/denominator/denominator-cli/4.5.0/denominator-cli-4.5.0-fat.jar"
  version "4.5.0"
  sha256 "3583720e813916d8ab69cc83403f9b34873016a282716846c5bc55ba8c75e5ac"

  def install
    bin.install "denominator-cli-4.5.0-fat.jar" => "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
