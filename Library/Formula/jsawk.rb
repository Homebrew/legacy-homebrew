require 'formula'

class Jsawk < Formula
  homepage 'https://github.com/micha/jsawk'
  url 'https://github.com/micha/jsawk/archive/1.2.tar.gz'
  sha1 '386ab745a07f650adac2e980d5a53ae037e495ed'

  head 'https://github.com/micha/jsawk.git'

  depends_on 'spidermonkey'

  def install
    mv "README.markdown", "README"
    bin.install "jsawk"
  end
end
