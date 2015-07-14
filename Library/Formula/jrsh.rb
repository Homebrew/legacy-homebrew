class Jrsh < Formula
  desc "A Command Line Interface for JasperReports Server"
  homepage "https://github.com/Krasnyanskiy/jrsh"
  url "https://github.com/Krasnyanskiy/jrsh/releases/download/v2.0.4/jrsh-2.0.4.zip"
  sha256 "b5a0471ffcc1c733c494e8c8c0c50eda9c5f786f829a7332601c8779ab1dba77"

  def install
    libexec.install "jrsh.jar"
    bin.write_jar_script libexec/"jrsh.jar", "jrsh"
  end

  test do
    system "#{bin}/jrsh"
  end
end
