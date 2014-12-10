require "formula"

class Checkstyle < Formula
  homepage "http://checkstyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/6.0/checkstyle-6.0-bin.tar.gz"
  sha1 "55628df367e55127205bb3d8f333db26bdf28b3c"

  def install
    libexec.install "checkstyle-#{version}-all.jar", "sun_checks.xml"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = `#{bin}/checkstyle -c #{libexec}/sun_checks.xml -r #{path}`
    errors = output.split("\n").select { |line| line.start_with?(path) }
    assert errors.include?("#{path}:1:17: '{' is not preceded with whitespace.")
    assert_equal errors.size, $?.exitstatus
  end
end
