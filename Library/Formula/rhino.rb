class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://www.mozilla.org/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_6_RELEASE/rhino1.7.6.zip"
  sha256 "45f4431699887a72a7f383ef927ef1b2e79d1fe597260af8df11ea93255b10f5"

  bottle :unneeded

  def install
    libexec.install "js.jar"
    bin.write_jar_script libexec/"js.jar", "rhino"
  end

  test do
    system "#{bin}/rhino", "-e", "print(42);"
  end
end
