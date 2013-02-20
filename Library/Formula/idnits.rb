require 'formula'

class Idnits < Formula
  homepage 'http://tools.ietf.org/tools/idnits/'
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.15.tgz'
  sha1 '54c7a6de881f4cdf8ceaae0042dc9d28e07d1641'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install_metafiles
  end
end
