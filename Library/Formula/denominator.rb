class Denominator < Formula
  homepage "https://github.com/Netflix/denominator/tree/v4.4.2/cli"
  url "https://bintray.com/artifact/download/netflixoss/maven/com/netflix/denominator/denominator-cli/4.4.2/denominator-cli-4.4.2-fat.jar"
  sha1 "b60b4dbcff98cc9d08f3eec1273c1ce3ff146860"

  def install
    bin.install "denominator-cli-4.4.2-fat.jar" => "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
