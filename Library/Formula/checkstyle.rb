class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "http://checkstyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/6.4.1/checkstyle-6.4.1-bin.tar.gz"
  sha256 "ff37bd1b81914dc67f71646cae991e2763d2c7d1d2bf8b73e3dad5506a818170"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = `#{bin}/checkstyle -c /sun_checks.xml #{path}`
    errors = output.split("\n").select { |line| line.start_with?(path) }
    assert errors.include?("#{path}:1:17: '{' is not preceded with whitespace.")
    assert_equal errors.size, $?.exitstatus
  end
end
