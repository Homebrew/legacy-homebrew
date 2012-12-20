require 'formula'

class Freeling < Formula
  homepage 'http://nlp.lsi.upc.edu/freeling/'
  url 'http://devel.cpl.upc.edu/freeling/downloads/21'
  version '3.0'
  sha1 'd05242e398f60d9720f9bbde2743ea469b1531d1'

  depends_on 'icu4c'
  # requires boost --with-icu.
  # At the moment I think that we can not force build options
  depends_on 'boost'
  depends_on 'libtool' => :build

  def install
    opoo 'Requires boost with icu support.'
    opoo 'If the installation fails, remove boost and do a \'brew install boost --with-icu\''

    icu4c_prefix = Formula.factory('icu4c').prefix
    libtool_prefix = Formula.factory('libtool').prefix
    ENV.append 'LDFLAGS', "-L#{libtool_prefix}/lib"
    ENV.append 'LDFLAGS', "-L#{icu4c_prefix}/lib"
    ENV.append 'CPPFLAGS', "-I#{libtool_prefix}/include"
    ENV.append 'CPPFLAGS', "-I#{icu4c_prefix}/include"

    system "./configure", "--prefix=#{prefix}"

    system "make install"
  end

  def test
    system "echo 'Hello world' | #{bin}/analyze -f #{share}/freeling/config/en.cfg | grep -c 'world world NN 1'"
  end

  def caveats; <<-EOS.undent
    This fomula requires that boost formula gets built with '--with-icu'
    option. If not, link will fail.

    If in doubt, try uninstalling boost (brew uninstall boost) and
    installint with ICU support (brew install --with-icu boost). For
    that you will also need icu4c installed (brew install icu4c).
    EOS
  end
end
