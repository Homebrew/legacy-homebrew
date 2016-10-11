require 'formula'

class Liquidsoap < Formula
  url 'http://sourceforge.net/projects/savonet/files/liquidsoap/1.0.0/liquidsoap-1.0.0-full.tar.bz2'
  homepage 'http://savonet.sf.net/'
  md5 'e379caaf68b1141b0b34bdb3db14ab69'
  version '1.0.0'

  depends_on 'objective-caml' => :build
  depends_on 'ocaml-findlib' => :build
  depends_on 'pcre-ocaml' => :build
  depends_on 'camomile'
  depends_on 'libao' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'mad' => :optional
  depends_on 'taglib' => :optional
  depends_on 'lame' => :optional
  depends_on 'flac' => :optional
  depends_on 'faad2' => :optional
  depends_on 'speex' => :optional
  depends_on 'theora' => :optional
  depends_on 'schroedinger' => :optional

  def install
    system 'cp PACKAGES.minimal PACKAGES'
    inreplace 'PACKAGES', 'ocaml-ao', '#ocaml-ao'  unless Formula.factory('libao').installed?
    inreplace 'PACKAGES', 'ocaml-ogg', '#ocaml-ogg'  unless Formula.factory('libogg').installed?
    inreplace 'PACKAGES', 'ocaml-vorbis', '#ocaml-vorbis'  unless Formula.factory('libvorbis').installed?
    inreplace 'PACKAGES', 'ocaml-mad', '#ocaml-mad'  unless Formula.factory('mad').installed?
    inreplace 'PACKAGES', 'ocaml-taglib', '#ocaml-taglib'  unless Formula.factory('taglib').installed?
    inreplace 'PACKAGES', 'ocaml-lame', '#ocaml-lame'  unless Formula.factory('lame').installed?
    inreplace 'PACKAGES', 'ocaml-flac', '#ocaml-flac'  unless Formula.factory('flac').installed?
    inreplace 'PACKAGES', '#ocaml-faad', 'ocaml-faad'  if Formula.factory('faad2').installed?
    inreplace 'PACKAGES', '#ocaml-speex', 'ocaml-speex' if Formula.factory('speex').installed?
    inreplace 'PACKAGES', '#ocaml-theora', 'ocaml-theora'  if Formula.factory('theora').installed?
    inreplace 'PACKAGES', '#ocaml-schroedinger', 'ocaml-schroedinger' if Formula.factory('schroedinger').installed?
    system './configure', "--prefix=#{prefix}"
    system 'make -j 2'
    system 'make doc'
    system 'rm INSTALL'
    system 'make install'
  end
end
