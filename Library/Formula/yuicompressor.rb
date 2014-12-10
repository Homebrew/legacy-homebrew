require 'formula'

class Yuicompressor < Formula
  homepage 'http://yui.github.io/yuicompressor/'
  url 'https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.zip'
  sha1 '178e265570c8161e8074c7ca19896abb05e76c1f'

  def install
    libexec.install "yuicompressor-#{version}.jar"
    bin.write_jar_script libexec/"yuicompressor-#{version}.jar", "yuicompressor"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      var i = 1;      // foo
      console.log(i); // bar
    EOS

    output = `#{bin}/yuicompressor --nomunge --preserve-semi #{path}`.strip
    assert_equal "var i=1;console.log(i);", output
    assert_equal 0, $?.exitstatus
  end
end
