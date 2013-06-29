require 'formula'

class Fop < Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz"
  sha1 '6b96c3f3fd5efe9f2b6b54bfa96161ec3f6a1dbc'

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/'fop'
  end
end
