require 'formula'

class Orpie < Formula
  homepage 'http://pessimization.com/software/orpie/'
  url 'http://pessimization.com/software/orpie/orpie-1.5.1.tar.gz'
  sha1 '4e4887d8abcf015a5b423a2d1164ace95ab2d5c1'

  depends_on 'gsl'
  depends_on 'objective-caml'

  def install
    # OCAMLOPT=/usr/bin/false prevents configure from finding ocaml.opt
    # so orpie is built and runs as bytecode otherwise the build
    # fails with "undefined symbol" errors.
    # This mechanism still works if /usr/bin/false doesn't exist,
    # although the build output will be uglier in that scenario.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "OCAMLOPT=/usr/bin/false"
    system "make"
    system "make install"
  end
end
