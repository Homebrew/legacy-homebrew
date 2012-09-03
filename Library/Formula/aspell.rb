require 'formula'

class AspellLang < Formula
  def install
    aspell = Formula.factory 'aspell'
    ENV.prepend 'PATH', aspell.bin, ':'
    system "./configure", "--vars", "ASPELL=#{aspell.bin}/aspell", "PREZIP=#{aspell.bin}/prezip"
    system "make install"
  end
end

class Aspell < Formula
  homepage 'http://aspell.net/'
  url 'http://ftpmirror.gnu.org/aspell/aspell-0.60.6.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'

  fails_with :llvm do
    build 2334
    cause "Segmentation fault during linking."
  end

  def options
    [
      ['--lang=XX,...', "Install dictionary for language XX where XX is the country code, e.g.: --lang=en,es\n\tAvailable country codes: #{available_languages.join(', ')}"],
      ['--all', "Install all available dictionaries"]
    ]
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    languages = []
    if ARGV.include?('--all')
      languages << available_languages.to_a
    else
      ARGV.options_only.select { |v| v =~ /--lang=/ }.uniq.each do |opt|
        languages << opt.split('=')[1].split(',')
      end
    end
    languages.flatten.each do |lang|
      begin
        formula = Object.const_get("Aspell_" + lang).new
      rescue
        opoo "Unknown language: #{lang}"
        next
      end
      formula.brew { formula.install }
    end
  end

  # TODO remove when options works properly
  def caveats; <<-EOS.undent
    Dictionaries are not automatically installed, please specify the languages
    for which you want dictionaries to be installed with the --lang option, e.g:
    % brew install aspell --lang=en,es

    For the following languages aspell dictionaries are available:
    #{available_languages.join(', ')}
    EOS
  end
end

# BEGIN generated with brew-aspell-dictionaries
class Aspell_af < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/af/aspell-af-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/af/aspell-af-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_am < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/am/aspell6-am-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/am/aspell6-am-0.03-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ar < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ast < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ast/aspell6-ast-0.01.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ast/aspell6-ast-0.01.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_az < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/az/aspell6-az-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/az/aspell6-az-0.02-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_be < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/be/aspell5-be-0.01.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/be/aspell5-be-0.01.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_bg < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_bn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_br < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/br/aspell-br-0.50-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ca < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_cs < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_csb < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_cy < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_da < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_de < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/de/aspell6-de-20030222-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_de_alt < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_el < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/el/aspell-el-0.50-3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/el/aspell-el-0.50-3.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_en < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/en/aspell6-en-7.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-7.1-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_eo < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_es < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/es/aspell6-es-1.11-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_et < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_fa < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_fi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_fo < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_fr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_fy < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ga < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_gd < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_gl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_grc < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_gu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_gv < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_he < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/he/aspell6-he-1.0-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_hi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_hil < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_hr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_hsb < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_hu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_hy < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ia < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_id < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/id/aspell5-id-1.2-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/id/aspell5-id-1.2-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_is < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_it < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_kn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ku < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ky < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_la < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/la/aspell6-la-20020503-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_lt < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_lv < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_mg < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_mi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_mk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ml < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_mn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_mr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ms < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_mt < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_nb < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_nds < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_nl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_nn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ny < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_or < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/or/aspell6-or-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/or/aspell6-or-0.03-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_pa < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_pl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_pt_BR < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_pt_PT < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_qu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ro < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ru < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_rw < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_sc < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sc/aspell5-sc-1.0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sc/aspell5-sc-1.0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_sk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_sl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_sr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sr/aspell6-sr-0.02.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sr/aspell6-sr-0.02.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_sv < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_sw < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_ta < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_te < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/te/aspell6-te-0.01-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/te/aspell6-te-0.01-2.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_tet < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_tk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_tl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_tn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_tr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_uk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_uz < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_vi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_wa < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_yi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end
class Aspell_zu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'
end

def available_languages
  %w( af am ar ast az be bg bn br ca cs csb cy da de de_alt el en eo es et fa fi fo fr fy ga gd gl grc gu gv he hi hil hr hsb hu hy ia id is it kn ku ky la lt lv mg mi mk ml mn mr ms mt nb nds nl nn ny or pa pl pt_BR pt_PT qu ro ru rw sc sk sl sr sv sw ta te tet tk tl tn tr uk uz vi wa yi zu)
end
# END generated with brew-aspell-dictionaries
