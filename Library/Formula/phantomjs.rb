class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  head "https://github.com/ariya/phantomjs.git"
  # Temporarily use Vitallium's fork (who is a maintainer) until 2.1.0.
  url "https://github.com/Vitallium/phantomjs.git",
      :tag => "2.0.1",
      :revision => "33aaaff64a197b20076faab1b08b8757516aa976"

  bottle do
    cellar :any
    sha256 "8c1e531d9d6f06a1c8cfd1a8b58de013c67311a63b7ef7527a74c94c96bd1a5b" => :el_capitan
    sha256 "6d70d6aa35b60f8ae26ac7a40c41ab0cb7e70a55b07abac6d236545116b83822" => :yosemite
    sha256 "8712122649fa42ca342fa98a4588dac3402f7038e11540e541e6dc80193cbe82" => :mavericks
  end

  depends_on "openssl"

  def install
    inreplace "src/qt/preconfig.sh", "QT_CFG+=' -openssl -openssl-linked'",
              "QT_CFG+=' -openssl -openssl-linked -I #{Formula["openssl"].opt_include} -L #{Formula["openssl"].opt_lib}'"
    system "./build.sh", "--confirm", "--jobs", ENV.make_jobs
    bin.install "bin/phantomjs"
    (share/"phantomjs").install "examples"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
