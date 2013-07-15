require 'formula'

class Idcomments < Formula
  homepage 'http://tools.ietf.org/tools/idcomments/'
  url 'http://tools.ietf.org/tools/idcomments/idcomments-0.18.tgz'
  sha1 'e7e6430926b0c502afcb55a91e90cd84d55c07d4'

  def install
    inreplace 'idcomments', '$(tempfile)', '$(mktemp /tmp/idcomments.XXXXXXXX)'
    bin.install 'idcomments'
    doc.install %w(about changelog copyright todo)
  end
end
