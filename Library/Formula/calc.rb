require 'formula'

class Calc < Formula
  homepage 'http://www.isthe.com/chongo/tech/comp/calc/'
  url 'http://www.isthe.com/chongo/src/calc/calc-2.12.4.4.tar.bz2'
  sha1 'cc55ee21ab7a7a6a8b7516a7236e87ae1b09d00d'

  depends_on 'readline'

  def install
    ENV.deparallelize

    ENV['EXTRA_CFLAGS'] = ENV.cflags
    ENV['EXTRA_LDFLAGS'] = ENV.ldflags

    readline = Formula.factory('readline')
    inreplace "Makefile" do |s|
      s.change_make_var! "INCDIR", include
      s.change_make_var! "BINDIR", bin
      s.change_make_var! "LIBDIR", lib
      s.change_make_var! "MANDIR", man1
      s.change_make_var! "CALC_SHAREDIR", "#{share}/calc"
      s.change_make_var! "USE_READLINE", "-DUSE_READLINE"
      s.change_make_var! "READLINE_LIB", "-L#{readline.lib} -lreadline"
      s.change_make_var! "READLINE_EXTRAS", "-lhistory -lncurses"
      s.change_make_var! "LIBCALC_SHLIB",
        "-single_module -undefined dynamic_lookup -dynamiclib -install_name ${LIBDIR}/libcalc${LIB_EXT_VERSION}"
      s.change_make_var! "LIBCUSTCALC_SHLIB",
        "-single_module -undefined dynamic_lookup -dynamiclib -install_name ${LIBDIR}/libcustcalc${LIB_EXT_VERSION}"
    end

    system "make"
    system "make install"
  end
end
