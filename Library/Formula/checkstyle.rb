require "formula"

class Checkstyle < Formula
  homepage "http://checkstyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/6.2/checkstyle-6.2-bin.tar.gz"
  sha1 "5b92798c55cbc8cf87f1435a2fc64e04d50a6648"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = `#{bin}/checkstyle -c /sun_checks.xml -r #{path}`
    errors = output.split("\n").select { |line| line.start_with?(path) }
    assert errors.include?("#{path}:1:17: '{' is not preceded with whitespace.")
    assert_equal errors.size, $?.exitstatus
  end
end
