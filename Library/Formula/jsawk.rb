require 'formula'

class Jsawk < Formula
  homepage 'https://github.com/micha/jsawk'
  url 'https://github.com/micha/jsawk/zipball/1.2'
  md5 'cf2c500c5bc5e546296e99f75f1c4fe6'
  head 'https://github.com/micha/jsawk.git'

  depends_on 'spidermonkey'

  def install
    system "mv README.markdown README"
    bin.install "jsawk"
  end
end
