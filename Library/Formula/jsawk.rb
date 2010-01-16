require 'formula'

class Jsawk <Formula
  head 'git://github.com/micha/jsawk.git'
  homepage 'http://github.com/micha/jsawk'
  
  # Is there a built-in JavaScript interpreter on OS X 10.6 we can use instead?
  depends_on 'spidermonkey'

  def install
    system "mv README.markdown README"
    bin.install "jsawk"
  end
end
