require 'formula'

class Lwt < Formula
  url 'http://ocsigen.org/download/lwt-2.3.2.tar.gz'
  homepage 'http://ocsigen.org/lwt'
  md5 'd1b4a8c1ad320c8f7876a8bff157d2d3'

  depends_on 'objective-caml'
  depends_on 'findlib'
  depends_on 'ocaml-text'
  depends_on 'react'
  depends_on 'libev'
  skip_clean :all

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX, '--enable-toplevel', '--enable-text', '--enable-react'
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make"
    system "make install"
  end
end
