require 'formula'

class Xmlm <Formula
  url 'http://erratique.ch/software/xmlm/releases/xmlm-1.0.2.tbz'
  homepage 'http://erratique.ch/software/xmlm'
  md5 '8c891f84b6e64892445071b7706ba1a2'

  depends_on 'objective-caml'
  depends_on 'findlib'

  def install
    ENV.deparallelize
    ENV.append "INSTALLDIR", "#{prefix}/lib/ocaml/site-lib/xmlm"
    system "./build", "install"
  end
end
