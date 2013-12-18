require 'formula'

class SaxonB < Formula
  homepage 'http://saxon.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/saxon/Saxon-B/9.1.0.8/saxonb9-1-0-8j.zip'
  version '9.1.0.8'
  sha1 '222186e188984967dddb92508510206d107aa194'

  def install
    (buildpath/'saxon-b').install Dir['*.jar', 'doc', 'notices']
    share.install Dir['*']
  end
end
