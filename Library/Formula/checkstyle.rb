class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "http://checkstyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/6.9/checkstyle-6.9-all.jar"
  sha256 "b97de32dd519744fe501dff90c1d8dc94c267c5fd5bc367be05dc1a693451502"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = `#{bin}/checkstyle -c /sun_checks.xml #{path}`
    errors = output.split("\n").select { |line| line.start_with?(path) }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $?.exitstatus
  end
end
