require 'formula'

class Idcomments < Formula
  url 'http://tools.ietf.org/tools/idcomments/idcomments-0.18.tgz'
  homepage 'http://tools.ietf.org/tools/idcomments/'
  md5 '6ceb271af37754657c7f81b3dba334de'

  def install
    inreplace 'idcomments', '$(tempfile)', '$(mktemp /tmp/idcomments.XXXXXXXX)'
    bin.install 'idcomments'
    doc.install %w(about changelog copyright todo)
  end
end
