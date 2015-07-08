class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "http://fantom.org"
  url "https://bitbucket.org/fantom/fan-1.0/downloads/fantom-1.0.67.zip"
  sha1 "36e45cc713c14b56df2bdbb19a8ccee98420ad1e"

  option "with-src", "Also install fantom source"
  option "with-examples", "Also install fantom examples"

  def install
    rm_f Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"]
    rm_rf "examples" if build.without? "examples"
    rm_rf "src" if build.without? "src"

    # Select the OS X JDK path in the config file
    inreplace "etc/build/config.props", "//jdkHome=/System", "jdkHome=/System"

    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.fan").write <<-EOS.undent
      class ATest {
        static Void main() { echo("a test") }
      }
    EOS

    assert_match "a test", shell_output("#{bin}/fan test.fan").chomp
  end
end
