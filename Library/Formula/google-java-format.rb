class GoogleJavaFormat < Formula
  desc "Tool to format java code with the google java format"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/google-java-format-0.1-alpha/google-java-format-0.1-alpha.jar"
  version "0.1-alpha"
  sha256 "4baec0288c8d676100342c4a7beb08758428bbad005209732250710d7b46f71f"

  bottle :unneeded

  def install
    libexec.install "google-java-format-#{version}.jar"
    bin.write_jar_script libexec/"google-java-format-#{version}.jar", "google-java-format"
  end

  test do
    system "#{bin}/google-java-format", "-v"
  end
end
