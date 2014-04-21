require 'formula'

class Jslint4java < Formula
  homepage 'http://code.google.com/p/jslint4java/'
  url 'https://jslint4java.googlecode.com/files/jslint4java-2.0.5-dist.zip'
  sha1 '30a75ce48b64d2c8f0b2b86e20c0d98e6441827d'

  def install
    doc.install Dir['docs/*']
    libexec.install Dir['*.jar']
    bin.write_jar_script Dir[libexec/'jslint4java*.jar'].first, 'jslint4java'
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS.undent
      var i = 0;
      var j = 1  // no semicolon
    EOS

    output = `#{bin}/jslint4java #{path}`
    assert output.include?("2:10:Expected ';' and instead saw '(end)'")
    assert_equal 1, $?.exitstatus
  end
end
