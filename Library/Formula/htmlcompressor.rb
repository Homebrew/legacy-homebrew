require 'formula'

class Htmlcompressor < Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.3.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  sha1 '57db73b92499e018b2f2978f1c7aa7b1238c7a39'

  def options
    [
      ['--yuicompressor', "Use YUICompressor for JS/CSS compression."],
    ]
  end

  depends_on "yuicompressor" if ARGV.include? '--yuicompressor'

  def install
    libexec.install "htmlcompressor-#{version}.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-#{version}.jar" $@
    EOS
    if ARGV.include? '--yuicompressor'
      yui = Formula.factory('yuicompressor')
      yui_jar = "yuicompressor-#{yui.version}.jar"
      ln_s "#{yui.libexec}/#{yui_jar}", "#{libexec}/#{yui_jar}"
    end
  end
end
