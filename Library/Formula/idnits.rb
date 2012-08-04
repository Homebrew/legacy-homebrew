require 'formula'

class Idnits < Formula
  homepage 'http://tools.ietf.org/tools/idnits/'
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.13.tgz'
  sha1 'd2a773ccca1a4eb00c4d001c6670a0131a6e939f'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
