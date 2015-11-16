class Bee < Formula
  desc "Tool for managing database changes."
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.54/bee-1.54.zip"
  sha256 "3b2e52d4d0cf69ee196fff1b06f4c0354ec496630d5fdff4ccac907eece437a5"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/bee"
  end

  test do
    (testpath/"bee.properties").write <<-EOS.undent
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "dbchange:create new-file"
  end
end
