require 'formula'

class SaxonB < Formula
  homepage 'http://saxon.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/saxon/Saxon-B/9.1.0.8/saxonb9-1-0-8j.zip'
  version '9.1.0.8'
  md5 'b1d08c1e2483e31021ed6e59c281c369'

  def install
    (buildpath/'saxon-b').install Dir['*.jar', 'doc', 'notices']
    share.install Dir['*']
  end
end
