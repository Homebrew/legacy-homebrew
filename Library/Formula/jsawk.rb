require 'formula'

class Jsawk <Formula
  head 'git://github.com/micha/jsawk.git'
  homepage 'http://github.com/micha/jsawk'

  depends_on 'spidermonkey'

  def install
    system "mv README.markdown README"
    bin.install "jsawk"
  end
end
