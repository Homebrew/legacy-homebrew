require 'formula'

class Fop < Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz"
  sha1 '6b96c3f3fd5efe9f2b6b54bfa96161ec3f6a1dbc'

  # http://offo.sourceforge.net/hyphenation/
  resource 'hyph' do
    url 'http://downloads.sourceforge.net/project/offo/offo-hyphenation-utf8/0.1/offo-hyphenation-fop-stable-utf8.zip'
    sha1 'c2a3f6e985b21c9702a714942ac747864c8b1759'
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/'fop'
    resource('hyph').stage do
      (libexec/'build').install 'fop-hyph.jar'
    end
  end
end
