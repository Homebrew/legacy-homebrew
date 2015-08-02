class Denominator < Formula
  desc "Portable Java library for manipulating DNS clouds"
  homepage "https://github.com/Netflix/denominator/tree/v4.6.0/cli"
  url "https://bintray.com/artifact/download/netflixoss/maven/com/netflix/denominator/denominator-cli/4.6.0/denominator-cli-4.6.0-fat.jar"
  version "4.6.0"
  sha256 "03317037e892d725154051f259aef3354166ea93515da9c27a02eb4becc320ec"

  def install
    bin.install "denominator-cli-4.6.0-fat.jar" => "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
