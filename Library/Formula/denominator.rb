class Denominator < Formula
  homepage "https://github.com/Netflix/denominator/tree/v4.5.0/cli"
  url "https://bintray.com/artifact/download/netflixoss/maven/com/netflix/denominator/denominator-cli/4.5.0/denominator-cli-4.5.0-fat.jar"
  sha1 "3bdcef1f4942605c2d49ff6823f10c0ace82338a"

  def install
    bin.install "denominator-cli-4.5.0-fat.jar" => "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
