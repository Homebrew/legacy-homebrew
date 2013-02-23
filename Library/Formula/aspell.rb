require 'formula'

class AspellLang < Formula
  def install
    aspell = Formula.factory 'aspell'
    ENV.prepend 'PATH', aspell.bin, ':'
    system "./configure", "--vars", "ASPELL=#{aspell.bin}/aspell", "PREZIP=#{aspell.bin}/prezip"
    system "make install"
  end
end

# BEGIN generated with brew-aspell-dictionaries
class Aspell_af < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/af/aspell-af-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/af/aspell-af-0.50-0.tar.bz2'
  sha1 '9957b57df8da90f0498c558481b0e6b1ce70af66'
end
class Aspell_am < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/am/aspell6-am-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/am/aspell6-am-0.03-1.tar.bz2'
  sha1 '837579f3bb085b6c491fd913cb35a3076659d2ee'
end
class Aspell_ar < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2'
  sha1 '35038cca52a8acbd042e98b1b158e5d612a11a48'
end
class Aspell_ast < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ast/aspell6-ast-0.01.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ast/aspell6-ast-0.01.tar.bz2'
  sha1 '4ee3b1a73c31d24db46a6b30f60a659d5e12aa40'
end
class Aspell_az < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/az/aspell6-az-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/az/aspell6-az-0.02-0.tar.bz2'
  sha1 '1ffe8b9674706f46b9daab564760c86a7b6ac63f'
end
class Aspell_be < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/be/aspell5-be-0.01.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/be/aspell5-be-0.01.tar.bz2'
  sha1 'd4a00c3b4ce6e3629c87217e1e0c8a34b905a2b0'
end
class Aspell_bg < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2'
  sha1 '0388f430a14f974fab67eaa92ebba3068eec7248'
end
class Aspell_bn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2'
  sha1 'c3adbfb8b6df04ba5cee2b25671f6119f86d67e5'
end
class Aspell_br < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/br/aspell-br-0.50-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2'
  sha1 'e6cbb638d7704e88c6d59b794829267b41a7e536'
end
class Aspell_ca < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2'
  sha1 'abce32e6dffa420b7ae90ac277038591e7c32a90'
end
class Aspell_cs < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2'
  sha1 '83756c070c1444f06c779a350d0bdad1d31e2b98'
end
class Aspell_csb < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2'
  sha1 '19640604cfe0035e14170d66653274779768bc3b'
end
class Aspell_cy < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2'
  sha1 '8a62c649cf99cd239449961a0d5f8942b1c02116'
end
class Aspell_da < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2'
  sha1 '8cc990c195707e2b4db4ed0969aa10117a3b6bb2'
end
class Aspell_de < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/de/aspell6-de-20030222-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2'
  sha1 'a06b1153404f6d1f9bd8aa03d596c14093e561c7'
end
class Aspell_de_alt < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2'
  sha1 '114092feb634b309e78e25d7c81fa0521916833b'
end
class Aspell_el < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/el/aspell-el-0.50-3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/el/aspell-el-0.50-3.tar.bz2'
  sha1 'f0242d02e45956f8fe5d8321d737ee4dc5d18931'
end
class Aspell_en < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/en/aspell6-en-7.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-7.1-0.tar.bz2'
  sha1 'd45ccda0c03e2a679c2936487ec851a1896b8150'
end
class Aspell_eo < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2'
  sha1 '0996e0b553bcb5706b598a0256c49102eb489c34'
end
class Aspell_es < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/es/aspell6-es-1.11-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2'
  sha1 '18acfa4bc08433e920bb015b158e43643e5125cf'
end
class Aspell_et < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2'
  sha1 '7376022dfea538be579d327db3a57696cce35e39'
end
class Aspell_fa < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2'
  sha1 '2d3427b9d274c0dbbcbbf78752afc19b1e31a41a'
end
class Aspell_fi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2'
  sha1 '10235c88220f7b914a1d8af7b4d4e8e26b5d7c76'
end
class Aspell_fo < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2'
  sha1 'da3dab3261df65df6765ad7fb7a9078f1a33d0ee'
end
class Aspell_fr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2'
  sha1 '4712f81069eb20763aaf855f73b2819f4805f132'
end
class Aspell_fy < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2'
  sha1 '8cfb4b506576b2a0d905d3abfa21bcd9bb2c2d67'
end
class Aspell_ga < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2'
  sha1 '0c4de4c1b55a73647ec5d20c2966bce8ebdb5a80'
end
class Aspell_gd < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2'
  sha1 '9b8593d4be9dd11c945a8f4e390bbf731897be76'
end
class Aspell_gl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2'
  sha1 '5f4f6d9ec134f54527380027e29f9f726040cb38'
end
class Aspell_grc < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2'
  sha1 'e9139a1961e8d3de1b3a4d6be823d920c6477dd7'
end
class Aspell_gu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2'
  sha1 'daf8bb6bcb84ad3d3fe5e03fffee572c41e17bb4'
end
class Aspell_gv < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2'
  sha1 '48bd30e8ce0cf229f7f369b20a304cf39a8cfc24'
end
class Aspell_he < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/he/aspell6-he-1.0-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2'
  sha1 'cd6755053937b9c32995d7fa085cd269489f5484'
end
class Aspell_hi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2'
  sha1 'af9ce9a4a97f2489a23d382bd72943b30bc3f6a4'
end
class Aspell_hil < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2'
  sha1 '2f25bd4d260420e8d94e50160eada2db175ae145'
end
class Aspell_hr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2'
  sha1 '6788b9001287f9debd59803f5f9c5005b701f8f7'
end
class Aspell_hsb < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2'
  sha1 '3bac178029f97a73f37b7196b974815af559d7dc'
end
class Aspell_hu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2'
  sha1 '0e020ed79ecfd5a88ec758482e31b757f54f60bf'
end
class Aspell_hus < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2'
  sha1 '5f54c8190375a12f50ab0df87997fa245ee7fa86'
end
class Aspell_hy < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2'
  sha1 'c24b59816222f5adff0c0f76316348524d93925b'
end
class Aspell_ia < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2'
  sha1 'aafc9e979c9b906b1b28b5001130a2b721835487'
end
class Aspell_id < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/id/aspell5-id-1.2-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/id/aspell5-id-1.2-0.tar.bz2'
  sha1 '7c4ce9252d74927a8b22a7af5260b3b22cc11a3c'
end
class Aspell_is < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2'
  sha1 '26c3a3bf047534cab163411735e8ff880b789ebe'
end
class Aspell_it < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2'
  sha1 '756e9c89f36eb0fdca951c818c2d3f2c52b9398d'
end
class Aspell_kn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2'
  sha1 '89d078ba50fddca9d7b0e9fd88ec3ba42a2137cc'
end
class Aspell_ku < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2'
  sha1 'ca8e15136f52345a506ea70fe922c45806fe171f'
end
class Aspell_ky < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2'
  sha1 '310367cbba994992bd801f13827ecd45f9bd2227'
end
class Aspell_la < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/la/aspell6-la-20020503-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2'
  sha1 '8f0ef073428955ffebff6dc31aaa84f13783b346'
end
class Aspell_lt < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2'
  sha1 '114c33dd042712dcef546b73dfbf889c1f7d7479'
end
class Aspell_lv < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2'
  sha1 'bbdebf5c7e959115dcbd1856327da11a84687d75'
end
class Aspell_mg < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2'
  sha1 '5a09a0a57c202433eac5cddf7a65c9095d8e748e'
end
class Aspell_mi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2'
  sha1 '837551b776a1e52987c6963e2c6382be9c8faa00'
end
class Aspell_mk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2'
  sha1 '08117e9d14543ca6d3626681d4b0eab51d53e727'
end
class Aspell_ml < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2'
  sha1 '5525ab8c2b956d62ffe9ad8651cab20841480e7e'
end
class Aspell_mn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2'
  sha1 '39d7e9adcefaa0e1d9dac41ad4f86b66dc9257c7'
end
class Aspell_mr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2'
  sha1 'bbcd0f26c93d37687284791eb7684a5277d6ff49'
end
class Aspell_ms < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2'
  sha1 '2f6bbe94bb717ee0009408f96800536891317d83'
end
class Aspell_mt < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2'
  sha1 '456b2fd40dd1d508947ed6ece14b00a61dd13138'
end
class Aspell_nb < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2'
  sha1 '40e2549973c192b82f782b9e0b1159e6b51464b3'
end
class Aspell_nds < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2'
  sha1 'b5cc46fac7a5436f9f52395c975ec66935b3ed54'
end
class Aspell_nl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2'
  sha1 '651ac98c63ce342b19dd9c1a74a961500234bc0a'
end
class Aspell_nn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2'
  sha1 '09c6cb3360ddbc231984e77608e911ee65a29b26'
end
class Aspell_ny < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2'
  sha1 'e2a654d042d028a7a7634ee3cbcd22c4e318b63f'
end
class Aspell_or < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/or/aspell6-or-0.03-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/or/aspell6-or-0.03-1.tar.bz2'
  sha1 'c1c8c48567dd5d28e48c00097b18859bd5a62d7d'
end
class Aspell_pa < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2'
  sha1 'b90300b077dbef4c1a25047ca9d84e8bc26681e3'
end
class Aspell_pl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2'
  sha1 '907852b5fbcdc643a84389cdf412aaf2bebff0ce'
end
class Aspell_pt_BR < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2'
  sha1 'add1db9a6a908dccaad13a7fd85c3b202299ff26'
end
class Aspell_pt_PT < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2'
  sha1 'e136c2f411b582897437b06b9068c98ee333be41'
end
class Aspell_qu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2'
  sha1 '4c530c06d0ae5cdcc857e02b7bf155dd0ccd80e9'
end
class Aspell_ro < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2'
  sha1 '98a64f2dade68bcff050b06567d09d40e727a2a2'
end
class Aspell_ru < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2'
  sha1 'e012fa03645f4ff1f5ba9df6b215ea4ffc6fd9cf'
end
class Aspell_rw < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2'
  sha1 '48248fa20e14b9369051360a37efdbadaf57d972'
end
class Aspell_sc < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sc/aspell5-sc-1.0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sc/aspell5-sc-1.0.tar.bz2'
  sha1 '4d94c9a3c5cc0c7f9af4e94074616073efa2374a'
end
class Aspell_sk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2'
  sha1 '8eb0bd453a1db4ad12863b833a2a3512ef43d30b'
end
class Aspell_sl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2'
  sha1 '028e41e39495ea32bc2318b9f91a9027e905479a'
end
class Aspell_sr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sr/aspell6-sr-0.02.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sr/aspell6-sr-0.02.tar.bz2'
  sha1 '4827f2b386861730f1fdc2e70cad48c0715a94e2'
end
class Aspell_sv < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2'
  sha1 'bcae409db1b26387e7a1b552fb135b07c5c85f73'
end
class Aspell_sw < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2'
  sha1 '3f525cdd25bb74577dcd1db9393d8348cf4dd656'
end
class Aspell_ta < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2'
  sha1 '7d9a96985af7bde014462c8973e3f2a75ad6ed27'
end
class Aspell_te < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/te/aspell6-te-0.01-2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/te/aspell6-te-0.01-2.tar.bz2'
  sha1 'b3a1df4c3e35fbdf0a2cd0db07c9b63372c9c94a'
end
class Aspell_tet < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2'
  sha1 '2b170ce5b4b866e61fd63a405ba7139b523a4e18'
end
class Aspell_tk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2'
  sha1 '40f10a6f5f252b9fac8fb49fc7bd89cc6b2c3046'
end
class Aspell_tl < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2'
  sha1 'ae9d5fad56ba162db0a33a9ece0e348298f2e3c6'
end
class Aspell_tn < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2'
  sha1 '595c6c10f823cf713e80505ccd15577ee7a77a65'
end
class Aspell_tr < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2'
  sha1 '3913b0227a8f2ad28760b965106980b4a60520e9'
end
class Aspell_uk < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2'
  sha1 'b4697fa6c8879aa54364839b0dceae5d9dc46b89'
end
class Aspell_uz < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2'
  sha1 '4662f5ec36afec8efdc2a5b29f2d1328cc14b829'
end
class Aspell_vi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2'
  sha1 'a497488786d796c677efd1bbf9df4c2eb511e728'
end
class Aspell_wa < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2'
  sha1 '06b5c0d0915b7e10db73c6aa548475ac1fcb3fcf'
end
class Aspell_yi < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2'
  sha1 'da49f8445ce89f656d9d75d5ee1a730126077896'
end
class Aspell_zu < AspellLang
  url 'http://ftpmirror.gnu.org/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2'
  sha1 '0cba6163d1a1b9f63b1f5eaaeba466cdaf5f0742'
end
def available_languages
  %w( af am ar ast az be bg bn br ca cs csb cy da de de_alt el en eo es et fa fi fo fr fy ga gd gl grc gu gv he hi hil hr hsb hu hus hy ia id is it kn ku ky la lt lv mg mi mk ml mn mr ms mt nb nds nl nn ny or pa pl pt_BR pt_PT qu ro ru rw sc sk sl sr sv sw ta te tet tk tl tn tr uk uz vi wa yi zu)
end
# END generated with brew-aspell-dictionaries

class Aspell < Formula
  homepage 'http://aspell.net/'
  url 'http://ftpmirror.gnu.org/aspell/aspell-0.60.6.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz'
  sha1 'ff1190db8de279f950c242c6f4c5d5cdc2cbdc49'

  fails_with :llvm do
    build 2334
    cause "Segmentation fault during linking."
  end

  option "all", "Install all available dictionaries"
  available_languages.each { |lang| option "with-lang-#{lang}", "Install #{lang} dictionary" }

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    languages = []

    available_languages.each do |lang|
      languages << lang if build.with? "lang-#{lang}"
    end

    if build.include? 'all'
      languages << available_languages.to_a
    elsif languages.empty?
      languages << "en"
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
end
