require 'formula'

class Idnits < Formula
  homepage 'http://tools.ietf.org/tools/idnits/'
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.17.tgz'
  sha1 'c8ccc80ee524dd200af5f34d266393301d60bdf5'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install_metafiles
  end
end
