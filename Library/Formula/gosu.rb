class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.9.1.tar.gz"
  sha256 "6a49719305a5da1605397dec05f2c9ce3213a57e4b7e19f509c824b20c6a93a9"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f1ea59b24b9ce7b715a4d8c807ff44c1ac7363b0058999606b6435c9bfaf1c1" => :el_capitan
    sha256 "bdb12be5f83952a4c47039ba977c3d5e59b66df5ddfb112931871c2af67679b4" => :yosemite
    sha256 "cf26bad9248ad53d3236c5b3c7b9a14c0486c5b3ce31ca457b2fe3340c41bb1a" => :mavericks
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    ENV.java_cache

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
