class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.9.1.tar.gz"
  sha256 "6a49719305a5da1605397dec05f2c9ce3213a57e4b7e19f509c824b20c6a93a9"
  head "https://github.com/gosu-lang/gosu-lang.git"

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    system "mvn", "package", "-Duser.home=#{buildpath}"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
