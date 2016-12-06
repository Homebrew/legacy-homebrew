require 'formula'

class OcamlText < Formula
  url 'http://forge.ocamlcore.org/frs/download.php/641/ocaml-text-0.5.tar.gz'
  homepage 'http://forge.ocamlcore.org/projects/ocaml-text/'
  md5 '5f004642ba19c1710ade13d46e2c1df2'

  depends_on 'objective-caml'
  depends_on 'findlib'
  skip_clean :all

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make"
    system "make install"
  end

end
