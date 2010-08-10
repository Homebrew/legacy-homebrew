require 'formula'

class AspellLang <Formula
  def install
    aspell = Formula.factory 'aspell'
    system "./configure --vars ASPELL=#{aspell.prefix}/bin/aspell PREZIP=#{aspell.prefix}/bin/prezip"
    system "PATH=$PATH:#{aspell.prefix}/bin; make install"
  end
end

class AspellAf <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/af/aspell-af-0.50-0.tar.bz2'
  md5 'bde617a195e70364f96eea71cf71a333'
end
class AspellAm <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/am/aspell6-am-0.03-1.tar.bz2'
  md5 '7e28708b53bd4bc3008dfb04237413ac'
end
class AspellAr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2'
  md5 '154cf762bafdd02db419b62191138738'
end
class AspellAz <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/az/aspell6-az-0.02-0.tar.bz2'
  md5 '24d9d46c8fc23197666a43a7962a7b0d'
end
class AspellBe <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/be/aspell5-be-0.01.tar.bz2'
  md5 '61314a1672f98571b32d23486bbd43be'
end
class AspellBg <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2'
  md5 'e22f0634c48eae9c9fbdf9d569b8235c'
end
class AspellBn <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2'
  md5 '5ea70ec74e67f49b2844d306ddf38388'
end
class AspellBr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2'
  md5 '800c7a28e09bd7734d1501cb7a91ad8f'
end
class AspellCa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2'
  md5 '153d26f724866909c6faf49eecefe8b3'
end
class AspellCs <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2'
  md5 '50f0c2b7b6fcfe47bb647ad8993d2fe8'
end
class AspellCy <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2'
  md5 'd59fee193dba87973b38ac2862a090bb'
end
class AspellDa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2'
  md5 'd14c03dca23b572606279d7317b022d0'
end
class AspellDe <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2'
  md5 '5950c5c8a36fc93d4d7616591bace6a6'
end
class AspellEl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/el/aspell-el-0.50-3.tar.bz2'
  md5 '0ea2c42ceb9b91f7f5de2c017234ad37'
end
class AspellEn <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-6.0-0.tar.bz2'
  md5 '16449e0a266e1ecc526b2f3cd39d4bc2'
end
class AspellEo <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2'
  md5 '455719c49ffeb51b204767de6e1d9ef6'
end
class AspellEs <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-1.9a-1.tar.bz2'
  md5 '473c980181e1930d075c6111a7a68e49'
end
class AspellEt <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2'
  md5 '82929f49ddc1149b6ef2bde4c3c12bcd'
end
class AspellFa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2'
  md5 '47c8599e529fc291a096c12f0b8372ca'
end
class AspellFi <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2'
  md5 '6d1032116982c0efab1af8fce83259c0'
end
class AspellFo <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2'
  md5 'a57e8870c272931da41cd1fc5a291f3d'
end
class AspellFr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2'
  md5 '53a2d05c4e8f7fabd3cefe24db977be7'
end
class AspellFy <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2'
  md5 '7c356ab9a52e546bdf75af8774b6d9bf'
end
class AspellGa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ga/aspell5-ga-4.4-0.tar.bz2'
  md5 '85eecae7fe14e06145d897e1fb736366'
end
class AspellGd <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2'
  md5 '171673ec92270f58f945c4317286220b'
end
class AspellGl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2'
  md5 '7502e37bf2a1c4a0a05f9a6e755e7c21'
end
class AspellGrc <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2'
  md5 '9a4ecc08569e4de53d35f16d1da02099'
end
class AspellGu <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2'
  md5 'dd9e466b23ced916d6bb89decc919976'
end
class AspellGv <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2'
  md5 '139b5aa1f5ea85fb7a4be0338039e959'
end
class AspellHe <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2'
  md5 '71791e0299787391d2ace1c850b5b434'
end
class AspellHi <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2'
  md5 '4fd4aedbda587bbc4eecb9d3ea57591d'
end
class AspellHr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2'
  md5 '7d2fb9af47266884c731691123a95a8d'
end
class AspellHsb <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/hsb/aspell6-hsb-0.01-1.tar.bz2'
  md5 'b7a0e5fa5843f080bfce2b441f46d981'
end
class AspellHu <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2'
  md5 '4f4e1e98019a89d0ebf43ec59ae68254'
end
class AspellHy <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2'
  md5 '41af00aed5078bb4755728c7dec834a2'
end
class AspellIa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2'
  md5 '36846c747a4cb7874b00f37752e83f25'
end
class AspellId <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/id/aspell5-id-1.2-0.tar.bz2'
  md5 '9136385a6ce0ff0d113427ab3c974254'
end
class AspellIs <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2'
  md5 '1e0b6125d91d7edad710482ddcce2d23'
end
class AspellIt <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2'
  md5 'b1217299a0b67d1e121494d7ec18a88d'
end
class AspellKu <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2'
  md5 '8d714169b131fc6ca8a783c6acc471ae'
end
class AspellKy <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2'
  md5 '83ed490464521361867546f9ad4cbaf2'
end
class AspellLa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2'
  md5 'd42c679b95ba9b094aaa65f118834bf6'
end
class AspellLt <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2'
  md5 'bfde48c27cac3ae8ce3a1818ba68a2d8'
end
class AspellLv <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2'
  md5 'cd120047c0b160a40361cbf03913e91f'
end
class AspellMg <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2'
  md5 'f75e3b51a6935cd4be19c1ea452217a1'
end
class AspellMi <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2'
  md5 '8b1a07032ee086662bfe44a2e0459db4'
end
class AspellMk <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2'
  md5 '50e15df6b68e78d1baa789f517b2401b'
end
class AspellMl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2'
  md5 '5ac03b3b0d0618b0aa470c9f5ac46866'
end
class AspellMn <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2'
  md5 'fd1ed8b4e57c858c62c4f74a687bba90'
end
class AspellMr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2'
  md5 '489ac0c368d3012525134758f8572cac'
end
class AspellMs <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2'
  md5 'cfdd94bba4781766c5d870202abd60e0'
end
class AspellMt <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2'
  md5 '6df98356e411891c956c249731b708fa'
end
class AspellNb <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2'
  md5 'd1173a5ce04f39e9c93183da691e7ce8'
end
class AspellNds <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2'
  md5 '76b2b3f2bdeefdfc6ce75ae11c9ae149'
end
class AspellNl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2'
  md5 'c3ef9fd7dc4c47d816eee9ef5149c76a'
end
class AspellNn <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2'
  md5 '3711eb9df68f25262af10119579239bc'
end
class AspellNy <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2'
  md5 '856906a424fcbc50cc925d692d294215'
end
class AspellOr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/or/aspell6-or-0.03-1.tar.bz2'
  md5 '6c9d702607eaa43ef665007c4b857ba4'
end
class AspellPa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2'
  md5 'de336d6ef55ad6fa81f8903765c6c95d'
end
class AspellPl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2'
  md5 '3139a69a1bd9ccb1d853d30aa024fc2b'
end
class AspellPtBr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2'
  md5 'e082a8956882eb94a67c12e1b8c4a324'
end
class AspellPtPt <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2'
  md5 'a54267ce8f91de6e6a1baf1e8048cba0'
end
class AspellQu <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2'
  md5 'b1c4a68fd5f46cadb600d925b0764fa5'
end
class AspellRo <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ro/aspell5-ro-3.1.tar.bz2'
  md5 '9be13b83c2eb441db38932933ae2a9c8'
end
class AspellRu <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2'
  md5 'c4c98eaa5e77ad3adccbc5c96cb57cb3'
end
class AspellRw <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2'
  md5 'd369916c4f4159b04e43daf31dde60c9'
end
class AspellSc <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/sc/aspell5-sc-1.0.tar.bz2'
  md5 '05284890c3445c5850a3c1410790a057'
end
class AspellSk <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2'
  md5 'b31bdc33a681902e5bc493a0692022a9'
end
class AspellSl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2'
  md5 'c4c11402bc834d796d1b56e711470480'
end
class AspellSr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/sr/aspell6-sr-0.02.tar.bz2'
  md5 'a068ba095e7246fd3bbc92e7d0287998'
end
class AspellSv <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2'
  md5 'd180c781f8986ea0f65b6b18f02a494e'
end
class AspellSw <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2'
  md5 '26ccc3500d7f7c288b74bba1c1fab38f'
end
class AspellTa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2'
  md5 'fc98b0b8d79291448d3a4f48ebbf2bd0'
end
class AspellTe <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/te/aspell6-te-0.01-2.tar.bz2'
  md5 '645f7f7204520552cddbe1c9ae64df2a'
end
class AspellTk <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2'
  md5 'acf208c098538eeacef444baf123ea3c'
end
class AspellTl <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2'
  md5 '126437909424021a553055b1b96fdf73'
end
class AspellTn <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2'
  md5 '6e5ef98452b36a211a4fc1fdbadda322'
end
class AspellTr <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2'
  md5 '432ecdc4e5233da0a4c1a52ed9103fa2'
end
class AspellUk <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2'
  md5 '662f15381d11581758866fd7af43b4d7'
end
class AspellUz <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2'
  md5 'e0d72a8250bba1a1f40dfb2a163eed65'
end
class AspellVi <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2'
  md5 '314185e521900df0fab8375fa609bba2'
end
class AspellWa <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2'
  md5 'e3817402d7be19d4b0d0342d3a5970ea'
end
class AspellYi <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2'
  md5 '9d514384bf00cfb9ceb0d5f78f998d93'
end
class AspellZu <AspellLang
  url 'http://ftp.gnu.org/gnu/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2'
  md5 '2478cbbb6abaf5ed74bc2da7e7152116'
end


class Aspell <Formula
  url 'ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.tar.gz'
  homepage 'http://aspell.net/'
  md5 'bc80f0198773d5c05086522be67334eb'

  def options
    [['--lang=XX,...',
    'Install dictionary for language XX where language is the 2 or 3 letter country code, e.g.: --lang=en,es']]
  end

  def install
    fails_with_llvm
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    ARGV.options_only.select { |v| v =~ /--lang=/ }.uniq.each do |opt|
      languages = opt.split('=')[1].split(',')
      languages.each do |lang|
        formula = Object.const_get("Aspell" + lang.capitalize).new
        formula.brew { formula.install }
      end
    end
  end

  # TODO remove when options works properly
  def caveats; <<-EOS
    To install dictionaries, eg:
      brew install aspell --lang=en
    EOS
  end
end
