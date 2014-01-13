require 'formula'

class Batik < Formula
  homepage 'https://xmlgraphics.apache.org/batik/'
  url 'http://www.us.apache.org/dist/xmlgraphics/batik/batik-1.7.zip'
  sha1 '69d974ab0a4e13cbdd649fa96785776563b73fcf'

  def install
    doc.install Dir['docs/*']
    libexec.install 'lib', Dir['*.jar']

    bin.write_jar_script libexec/'batik-rasterizer.jar', 'batik-rasterizer'
    bin.write_jar_script libexec/'batik.jar', 'batik'
    bin.write_jar_script libexec/'batik-ttf2svg.jar', 'batik-ttf2svg'
  end
end
