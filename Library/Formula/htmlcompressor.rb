require 'formula'

class Htmlcompressor < Formula
  homepage 'http://code.google.com/p/htmlcompressor/'
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.3.jar'
  sha1 '57db73b92499e018b2f2978f1c7aa7b1238c7a39'

  option 'yuicompressor', "Use YUICompressor for JS/CSS compression"
  option 'closure-compiler', "Use Closure Compiler for JS optimization"

  depends_on "yuicompressor" if build.include? 'yuicompressor'
  depends_on "closure-compiler" if build.include? 'closure-compiler'

  def install
    libexec.install "htmlcompressor-#{version}.jar"
    bin.write_jar_script libexec/"htmlcompressor-#{version}.jar", "htmlcompressor"

    if build.include? 'yuicompressor'
      yui = Formula["yuicompressor"]
      yui_jar = "yuicompressor-#{yui.version}.jar"
      ln_s "#{yui.opt_prefix}/libexec/#{yui_jar}", "#{libexec}/#{yui_jar}"
    end

    if build.include? 'closure-compiler'
      closure = Formula["closure-compiler"]
      ln_s "#{closure.opt_prefix}/libexec/build/compiler.jar", "#{libexec}/compiler.jar"
    end
  end

  test do
    path = testpath/"index.xml"
    path.write <<-EOS
      <foo>
        <bar /> <!-- -->
      </foo>
    EOS

    output = `#{bin}/htmlcompressor #{path}`.strip
    assert_equal "<foo><bar/></foo>", output
    assert_equal 0, $?.exitstatus
  end
end
