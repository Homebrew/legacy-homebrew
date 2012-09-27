require 'formula'

class Jsawk < Formula
  homepage 'https://github.com/micha/jsawk'
  url 'https://github.com/micha/jsawk/zipball/1.2'
  sha1 '45f1cd62e146240d9ec8a595425a6d9368f369d6'
  head 'https://github.com/micha/jsawk.git'

  depends_on 'spidermonkey'

  def install
    system "mv README.markdown README"
    bin.install "jsawk"
  end
end
