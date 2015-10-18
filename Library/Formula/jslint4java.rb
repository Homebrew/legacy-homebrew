class Jslint4java < Formula
  desc "Java wrapper for JavaScript Lint (jsl)"
  homepage "https://code.google.com/p/jslint4java/"
  url "https://jslint4java.googlecode.com/files/jslint4java-2.0.5-dist.zip"
  sha256 "078240b17256a0472f9981d68f11556238658ebaa67be49ea49958adafc96a81"

  def install
    doc.install Dir["docs/*"]
    libexec.install Dir["*.jar"]
    bin.write_jar_script Dir[libexec/"jslint4java*.jar"].first, "jslint4java"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS.undent
      var i = 0;
      var j = 1  // no semicolon
    EOS
    output = shell_output("#{bin}/jslint4java #{path}", 1)
    assert output.include?("2:10:Expected ';' and instead saw '(end)'")
  end
end
