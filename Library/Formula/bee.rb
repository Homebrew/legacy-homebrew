class Bee < Formula
  desc "Tool for managing database changes."
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.53/bee-1.53.zip"
  sha256 "022784746e96e22f4b6f407ceaaccd63d212d5fb83b3394fc620319e4f7c3842"

  def install
    rm_rf Dir["bin/*.bat"]
    bin.install Dir["bin/*"]
    lib.install Dir["lib/*"]
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
