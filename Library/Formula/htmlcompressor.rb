require 'formula'

class Htmlcompressor < Formula
  homepage 'http://code.google.com/p/htmlcompressor/'
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.3.jar'
  sha1 '57db73b92499e018b2f2978f1c7aa7b1238c7a39'

  option 'yuicompressor', "Use YUICompressor for JS/CSS compression"

  depends_on "yuicompressor" => :optional if build.include? 'yuicompressor'

  def install
    libexec.install "htmlcompressor-#{version}.jar"

    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-#{version}.jar" "$@"
    EOS

    if build.include? 'yuicompressor'
      yui = Formula.factory('yuicompressor')
      yui_jar = "yuicompressor-#{yui.version}.jar"
      ln_s "#{yui.libexec}/#{yui_jar}", "#{libexec}/#{yui_jar}"
    end
  end
end
