require 'formula'

class XmlLight < Formula
  url 'http://tech.motion-twin.com/zip/xml-light-2.2.zip'
  homepage 'http://tech.motion-twin.com/xmllight.html'
  md5 '7658985cfdaeeb94b579b932eeaa3e00'

  depends_on 'objective-caml'

  def install
    # NOTE: This series of calls to make are somehow necessary, at least
    #       on my system, to build the library. However, I can install it
    #       manually simply by running "make install" from a shell.
    system "make dtd.cmi"
    system "make xml_parser.ml"
    system "make all"
    system "make opt"
    # NOTE: This installs to `ocamlc -where`, which is typically
    #           /usr/local/lib/ocaml
    #       Running "brew remove" does not remove these files.
    #       The installation directory can be overriden as follows:
    #           make install INSTALLDIR=/some/path
    system "make install"
  end
end
