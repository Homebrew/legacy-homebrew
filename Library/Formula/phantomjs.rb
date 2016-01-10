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
    sha256 "568b89a804eb0c823bed4f8970324857f8c9200e2ef141276e3f78576132e996" => :yosemite
    sha256 "160e52917066631b087046e765788efba92c1cd930f0cc996454e58b7d90b232" => :mavericks
    sha256 "45091efed57f4de5f04810a874e050206ae587ac85e17892f570e0e7eb50b977" => :mountain_lion
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
