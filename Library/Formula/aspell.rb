class Aspell < Formula
  desc "Spell checker with better logic than ispell"
  homepage "http://aspell.net/"
  url "http://ftpmirror.gnu.org/aspell/aspell-0.60.6.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz"
  sha256 "f52583a83a63633701c5f71db3dc40aab87b7f76b29723aeb27941eff42df6e1"

  bottle do
    sha256 "ccc60cb56f23d7ad911ae2b564c1257ba0e5136e069b9cff6372a12bd720ce64" => :el_capitan
    sha256 "cbef227317d456df1bb54e11aa041ed28a445a95fb0b8517c1a352b01634026b" => :yosemite
    sha256 "2c254cad4de36437852bf34806f3766b90013ea52310eb4b7afcb7eb2399d970" => :mavericks
    sha256 "138549002ae369e1659a990ef26b30e500cab4f5cd0a21b80290946099fee6d0" => :mountain_lion
  end

  devel do
    url "http://alpha.gnu.org/gnu/aspell/aspell-0.60.7-20110707.tar.gz"
    sha256 "084005bd37013f17b725eca033fe19053b2ab33144e990685486746cb10416a5"
    version "0.60.7-20110707"
  end

  option "with-lang-af", "Install af dictionary"
  resource "af" do
    url "http://ftpmirror.gnu.org/aspell/dict/af/aspell-af-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/af/aspell-af-0.50-0.tar.bz2"
    sha256 "9d6000aeca5911343278bd6ed9e21d42c8cb26247dafe94a76ff81d8ac98e602"
  end

  option "with-lang-am", "Install am dictionary"
  resource "am" do
    url "http://ftpmirror.gnu.org/aspell/dict/am/aspell6-am-0.03-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/am/aspell6-am-0.03-1.tar.bz2"
    sha256 "bf27dd21f8871e2b3332c211b402cd46604d431a7773e599729c242cdfb9d487"
  end

  option "with-lang-ar", "Install ar dictionary"
  resource "ar" do
    url "http://ftpmirror.gnu.org/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2"
    sha256 "041ea24a82cdd6957040e2fb84262583bf46b3a8301283a75d257a7417207cab"
  end

  option "with-lang-ast", "Install ast dictionary"
  resource "ast" do
    url "http://ftpmirror.gnu.org/aspell/dict/ast/aspell6-ast-0.01.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ast/aspell6-ast-0.01.tar.bz2"
    sha256 "43f23ed01c338c37f9bbb820db757b36ede1cea47a7b93dc8b6d7bd66b410f92"
  end

  option "with-lang-az", "Install az dictionary"
  resource "az" do
    url "http://ftpmirror.gnu.org/aspell/dict/az/aspell6-az-0.02-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/az/aspell6-az-0.02-0.tar.bz2"
    sha256 "063176ec459d61acd59450ae49b5076e42abb1dcd54c1f934bae5fa6658044c3"
  end

  option "with-lang-be", "Install be dictionary"
  resource "be" do
    url "http://ftpmirror.gnu.org/aspell/dict/be/aspell5-be-0.01.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/be/aspell5-be-0.01.tar.bz2"
    sha256 "550bad0c03a142241ffe5ecc183659d80020b566003a05341cd1e97c6ed274eb"
  end

  option "with-lang-bg", "Install bg dictionary"
  resource "bg" do
    url "http://ftpmirror.gnu.org/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2"
    sha256 "74570005dc2be5a244436fa2b46a5f612be84c6843f881f0cb1e4c775f658aaa"
  end

  option "with-lang-bn", "Install bn dictionary"
  resource "bn" do
    url "http://ftpmirror.gnu.org/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2"
    sha256 "b03f9cc4feb00df9bfd697b032f4f4ae838ad5a6bb41db798eefc5639a1480d9"
  end

  option "with-lang-br", "Install br dictionary"
  resource "br" do
    url "http://ftpmirror.gnu.org/aspell/dict/br/aspell-br-0.50-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2"
    sha256 "c2122a6dcca653c082d785f0da4bf267363182a017fea4129e8b0882aa6d2a3b"
  end

  option "with-lang-ca", "Install ca dictionary"
  resource "ca" do
    url "http://ftpmirror.gnu.org/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2"
    sha256 "ebdae47edf87357a4df137dd754737e6417452540cb1ed34b545ccfd66f165b9"
  end

  option "with-lang-cs", "Install cs dictionary"
  resource "cs" do
    url "http://ftpmirror.gnu.org/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2"
    sha256 "01c091f907c2fa4dfa38305c2494bb80009407dfb76ead586ad724ae21913066"
  end

  option "with-lang-csb", "Install csb dictionary"
  resource "csb" do
    url "http://ftpmirror.gnu.org/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2"
    sha256 "c166ad07d50e9e13ac9f87d5a8938b3f675a0f8a01017bd8969c2053e7f52298"
  end

  option "with-lang-cy", "Install cy dictionary"
  resource "cy" do
    url "http://ftpmirror.gnu.org/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2"
    sha256 "d5399dcd70061e5ed5af1214eb580f62864dd35ea4fa1ec2882ffc4f03307897"
  end

  option "with-lang-da", "Install da dictionary"
  resource "da" do
    url "http://ftpmirror.gnu.org/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2"
    sha256 "f74a079617979c1623e8e7313e4ecd3bc260db92ce55b1f2a3a5e7077dacd3c1"
  end

  option "with-lang-de", "Install de dictionary"
  resource "de" do
    url "http://ftpmirror.gnu.org/aspell/dict/de/aspell6-de-20030222-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2"
    sha256 "ba6c94e11bc2e0e6e43ce0f7822c5bba5ca5ac77129ef90c190b33632416e906"
  end

  option "with-lang-de_alt", "Install de_alt dictionary"
  resource "de_alt" do
    url "http://ftpmirror.gnu.org/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2"
    sha256 "36d13c6c743a6b1ff05fb1af79134e118e5a94db06ba40c076636f9d04158c73"
  end

  option "with-lang-el", "Install el dictionary"
  resource "el" do
    url "http://ftpmirror.gnu.org/aspell/dict/el/aspell-el-0.50-3.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/el/aspell-el-0.50-3.tar.bz2"
    sha256 "3f6508937dcaa64a6c70ee5f722f088b46b202a6409961b93b705d4ec4f56380"
  end

  option "with-lang-en", "Install en dictionary"
  resource "en" do
    url "http://ftpmirror.gnu.org/aspell/dict/en/aspell6-en-2015.02.15-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2015.02.15-0.tar.bz2"
    sha256 "865ba3492b54cad102d9de4c0e59494710ca018e0341057ade66bde32d58182a"
  end

  option "with-lang-eo", "Install eo dictionary"
  resource "eo" do
    url "http://ftpmirror.gnu.org/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2"
    sha256 "41d2d18d6a4de6422185a31ecfc1a3de2e751f3dfb2cbec8f275b11857056e27"
  end

  option "with-lang-es", "Install es dictionary"
  resource "es" do
    url "http://ftpmirror.gnu.org/aspell/dict/es/aspell6-es-1.11-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2"
    sha256 "ad367fa1e7069c72eb7ae37e4d39c30a44d32a6aa73cedccbd0d06a69018afcc"
  end

  option "with-lang-et", "Install et dictionary"
  resource "et" do
    url "http://ftpmirror.gnu.org/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2"
    sha256 "b1e857aa3daaea2a19462b2671e87c26a7eb7337c83b709685394eed8472b249"
  end

  option "with-lang-fa", "Install fa dictionary"
  resource "fa" do
    url "http://ftpmirror.gnu.org/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2"
    sha256 "482d26ea879a8ea02d9373952205f67e07c85a7550841b13b5079bb2f9f2e15b"
  end

  option "with-lang-fi", "Install fi dictionary"
  resource "fi" do
    url "http://ftpmirror.gnu.org/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2"
    sha256 "f8d7f07b4511e606eb56392ddaa76fd29918006331795e5942ad11b510d0a51d"
  end

  option "with-lang-fo", "Install fo dictionary"
  resource "fo" do
    url "http://ftpmirror.gnu.org/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2"
    sha256 "f7e0ddc039bb4f5c142d39dab72d9dfcb951f5e46779f6e3cf1d084a69f95e08"
  end

  option "with-lang-fr", "Install fr dictionary"
  resource "fr" do
    url "http://ftpmirror.gnu.org/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2"
    sha256 "f9421047519d2af9a7a466e4336f6e6ea55206b356cd33c8bd18cb626bf2ce91"
  end

  option "with-lang-fy", "Install fy dictionary"
  resource "fy" do
    url "http://ftpmirror.gnu.org/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2"
    sha256 "3447cfa90e459af32183a6bc8af9ba3ed571087811cdfc336821454bac8995aa"
  end

  option "with-lang-ga", "Install ga dictionary"
  resource "ga" do
    url "http://ftpmirror.gnu.org/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2"
    sha256 "455fdbbca24cecb4667fbcf9544d84ae83e5b2505caae79afa6b2cb76b4d0679"
  end

  option "with-lang-gd", "Install gd dictionary"
  resource "gd" do
    url "http://ftpmirror.gnu.org/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2"
    sha256 "e316a08a75da8a0d4d15eb892023073a971e0a326382a5532db29856768e0929"
  end

  option "with-lang-gl", "Install gl dictionary"
  resource "gl" do
    url "http://ftpmirror.gnu.org/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2"
    sha256 "b3cdcf65971e70b8c09fb7f319164c6344a80d260b6e98dc6ecca1e02b7cfc8a"
  end

  option "with-lang-grc", "Install grc dictionary"
  resource "grc" do
    url "http://ftpmirror.gnu.org/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2"
    sha256 "2214883e2b9883f360b090948afd2cb0687bc6bba4e1e98011fb8c8d4a42b9ff"
  end

  option "with-lang-gu", "Install gu dictionary"
  resource "gu" do
    url "http://ftpmirror.gnu.org/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2"
    sha256 "432c125acc6a86456061dcd47018df4318a117be9f7c09a590979243ad448311"
  end

  option "with-lang-gv", "Install gv dictionary"
  resource "gv" do
    url "http://ftpmirror.gnu.org/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2"
    sha256 "bbe626feb5c81c1b7e7d3199d558bc5c560b2d4aef377d0e4b4227ae3c7176e6"
  end

  option "with-lang-he", "Install he dictionary"
  resource "he" do
    url "http://ftpmirror.gnu.org/aspell/dict/he/aspell6-he-1.0-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2"
    sha256 "d64dabac9f40ca9e632a8eee40fc01c7d18a2c699d8f9742000fadd2e15b708d"
  end

  option "with-lang-hi", "Install hi dictionary"
  resource "hi" do
    url "http://ftpmirror.gnu.org/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2"
    sha256 "da0778c46716f4209da25195294139c2f5e6031253381afa4f81908fc9193a37"
  end

  option "with-lang-hil", "Install hil dictionary"
  resource "hil" do
    url "http://ftpmirror.gnu.org/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2"
    sha256 "570a374fd0b97943bc6893cf25ac7b23da815120842a80144e2c7ee8b41388e8"
  end

  option "with-lang-hr", "Install hr dictionary"
  resource "hr" do
    url "http://ftpmirror.gnu.org/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2"
    sha256 "2ac4030354d7961e45d63b46e06e59248d59cc70dfc9e1d8ee0ae21d9c774a25"
  end

  option "with-lang-hsb", "Install hsb dictionary"
  resource "hsb" do
    url "http://ftpmirror.gnu.org/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2"
    sha256 "8d9f2ae428c7754a922ce6a7ef23401bc65f6f1909aec5077975077b3edc222e"
  end

  option "with-lang-hu", "Install hu dictionary"
  resource "hu" do
    url "http://ftpmirror.gnu.org/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2"
    sha256 "3335a7b45cf9774bccf03740fbddeb7ec4752dd87178fa93f92d4c71e3f236b5"
  end

  option "with-lang-hus", "Install hus dictionary"
  resource "hus" do
    url "http://ftpmirror.gnu.org/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2"
    sha256 "6d28f371d1a172439395d56d2d5ce8f27c617de03f847f02643dfd79dd8df425"
  end

  option "with-lang-hy", "Install hy dictionary"
  resource "hy" do
    url "http://ftpmirror.gnu.org/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2"
    sha256 "2dea8d0093a3b8373cc97703dca2979b285f71916181d1a20db70bea28c2bcf0"
  end

  option "with-lang-ia", "Install ia dictionary"
  resource "ia" do
    url "http://ftpmirror.gnu.org/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2"
    sha256 "5797cb59606d007cf8fe5b9ec435de0d63b2d0e0d391ed8850ef8aa3f4bb0c2f"
  end

  option "with-lang-id", "Install id dictionary"
  resource "id" do
    url "http://ftpmirror.gnu.org/aspell/dict/id/aspell5-id-1.2-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/id/aspell5-id-1.2-0.tar.bz2"
    sha256 "523912082848d891746dbb233f2ddb2cdbab6750dc76c38b3f6e000c9eb37308"
  end

  option "with-lang-is", "Install is dictionary"
  resource "is" do
    url "http://ftpmirror.gnu.org/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2"
    sha256 "3035bd29dad929ce66e6acdc7c29670df458e0d13fe178241b212f481111e3d6"
  end

  option "with-lang-it", "Install it dictionary"
  resource "it" do
    url "http://ftpmirror.gnu.org/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2"
    sha256 "3b19dc709924783c8d87111aa9653dc6c000e845183778abee750215d83aaebd"
  end

  option "with-lang-kn", "Install kn dictionary"
  resource "kn" do
    url "http://ftpmirror.gnu.org/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2"
    sha256 "cb010b34a712f853fa53c4618cb801704b9f76c72db9390009ba914e3a075383"
  end

  option "with-lang-ku", "Install ku dictionary"
  resource "ku" do
    url "http://ftpmirror.gnu.org/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2"
    sha256 "968f76418c991dc004a1cc3d8cd07b58fb210b6ad506106857ed2d97274a6a27"
  end

  option "with-lang-ky", "Install ky dictionary"
  resource "ky" do
    url "http://ftpmirror.gnu.org/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2"
    sha256 "e10f2f25b44b71e30fa1ea9c248c04543c688845a734d0b9bdc65a2bbd16fb4f"
  end

  option "with-lang-la", "Install la dictionary"
  resource "la" do
    url "http://ftpmirror.gnu.org/aspell/dict/la/aspell6-la-20020503-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2"
    sha256 "d486b048d1c3056d3a555744584a81873a63ecd4641f04e8b7bf9910b98d2985"
  end

  option "with-lang-lt", "Install lt dictionary"
  resource "lt" do
    url "http://ftpmirror.gnu.org/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2"
    sha256 "f6f53b6e418c22f63e1a70b8bc77bc66912bc1afd40cf98dc026d110d26452ab"
  end

  option "with-lang-lv", "Install lv dictionary"
  resource "lv" do
    url "http://ftpmirror.gnu.org/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2"
    sha256 "3c30e206ea562b2e759fb7467680e1a01d5deec5edbd66653c83184550d1fb8a"
  end

  option "with-lang-mg", "Install mg dictionary"
  resource "mg" do
    url "http://ftpmirror.gnu.org/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2"
    sha256 "5182f832e1630ceef5711a83b530fb583ffe04f28cc042d195b5c6b2d25cb041"
  end

  option "with-lang-mi", "Install mi dictionary"
  resource "mi" do
    url "http://ftpmirror.gnu.org/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2"
    sha256 "beee1e33baf6301e3ffc56558c84c3e7d29622541b232c1aea1e91d12ebd7d89"
  end

  option "with-lang-mk", "Install mk dictionary"
  resource "mk" do
    url "http://ftpmirror.gnu.org/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2"
    sha256 "15fc2380fb673d2003d8075d8cef2b0dbb4d30b430587ad459257681904d9971"
  end

  option "with-lang-ml", "Install ml dictionary"
  resource "ml" do
    url "http://ftpmirror.gnu.org/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2"
    sha256 "e4cd551e558b6d26e4db58e051eeca3d893fc2c4e7fce90a022af247422096fd"
  end

  option "with-lang-mn", "Install mn dictionary"
  resource "mn" do
    url "http://ftpmirror.gnu.org/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2"
    sha256 "2f1b6edd48b82cd9b99b9262d5635f72271c062ef4e772b90388dfc48a4f1294"
  end

  option "with-lang-mr", "Install mr dictionary"
  resource "mr" do
    url "http://ftpmirror.gnu.org/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2"
    sha256 "d3a35a40bee0234a5b388375485ab8bf0ba8edbf3b0a82e2c2f76a40a8586f33"
  end

  option "with-lang-ms", "Install ms dictionary"
  resource "ms" do
    url "http://ftpmirror.gnu.org/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2"
    sha256 "3cc4e3537bb0f455ce58b4d2fa84b03dc678e0153536a41dee1a3a7623dc246f"
  end

  option "with-lang-mt", "Install mt dictionary"
  resource "mt" do
    url "http://ftpmirror.gnu.org/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2"
    sha256 "e00fcaad60a90cfed687ba02f62be8c27b8650457dd3c5bdcb064b476da059b4"
  end

  option "with-lang-nb", "Install nb dictionary"
  resource "nb" do
    url "http://ftpmirror.gnu.org/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2"
    sha256 "e7746e8b617b2df576c1172399544818084524504202b16c747f52db5e5d228a"
  end

  option "with-lang-nds", "Install nds dictionary"
  resource "nds" do
    url "http://ftpmirror.gnu.org/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2"
    sha256 "ce381e869def56e54a31f965df518deca0e6f12238859650fcb115623f8772da"
  end

  option "with-lang-nl", "Install nl dictionary"
  resource "nl" do
    url "http://ftpmirror.gnu.org/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2"
    sha256 "440e0b7df8c5903d728221fe4ba88a74658ce14c8bb04b290c41402dfd41cb39"
  end

  option "with-lang-nn", "Install nn dictionary"
  resource "nn" do
    url "http://ftpmirror.gnu.org/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2"
    sha256 "ac6610540c7e134f09cbebbd148f9316bef27bc491e377638ef4e2950b2d5370"
  end

  option "with-lang-ny", "Install ny dictionary"
  resource "ny" do
    url "http://ftpmirror.gnu.org/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2"
    sha256 "176f970f6ba3bb448c7e946fa8d209eb4da7138ac6899af7731a98c7b6484b3e"
  end

  option "with-lang-or", "Install or dictionary"
  resource "or" do
    url "http://ftpmirror.gnu.org/aspell/dict/or/aspell6-or-0.03-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/or/aspell6-or-0.03-1.tar.bz2"
    sha256 "d6ffa369f8918d74cdea966112bc5cb700e09dca5ac6b968660cfc22044ef24f"
  end

  option "with-lang-pa", "Install pa dictionary"
  resource "pa" do
    url "http://ftpmirror.gnu.org/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2"
    sha256 "c7f3abb1c5efe62e072ca8bef44b0d0506501bbb7b48ced1d0d95f10e61fc945"
  end

  option "with-lang-pl", "Install pl dictionary"
  resource "pl" do
    url "http://ftpmirror.gnu.org/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2"
    sha256 "017741fcb70a885d718c534160c9de06b03cc72f352879bd106be165e024574d"
  end

  option "with-lang-pt_BR", "Install pt_BR dictionary"
  resource "pt_BR" do
    url "http://ftpmirror.gnu.org/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2"
    sha256 "77fc554aa9bbd5f4a87b58edf0d128838e92e4db6299904bb9360bf753a709f8"
  end

  option "with-lang-pt_PT", "Install pt_PT dictionary"
  resource "pt_PT" do
    url "http://ftpmirror.gnu.org/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2"
    sha256 "b8b7a71a480f2a6659a3ab1e6069d4be7a9a929fc520e4a1364f51ce484ad9d6"
  end

  option "with-lang-qu", "Install qu dictionary"
  resource "qu" do
    url "http://ftpmirror.gnu.org/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2"
    sha256 "80977629b8425bda7ffd951628d23a6793a457f4948151c71ff9e0bff5073f01"
  end

  option "with-lang-ro", "Install ro dictionary"
  resource "ro" do
    url "http://ftpmirror.gnu.org/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2"
    sha256 "53c38b7668a540cf90ddca11c007ce812d2ad86bd11c2c43a08da9e06392683d"
  end

  option "with-lang-ru", "Install ru dictionary"
  resource "ru" do
    url "http://ftpmirror.gnu.org/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2"
    sha256 "5c29b6ccce57bc3f7c4fb0510d330446b9c769e59c92bdfede27333808b6e646"
  end

  option "with-lang-rw", "Install rw dictionary"
  resource "rw" do
    url "http://ftpmirror.gnu.org/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2"
    sha256 "3406102e0e33344b6eae73dbfaf86d8e411b7c97775827a6db79c943ce43f081"
  end

  option "with-lang-sc", "Install sc dictionary"
  resource "sc" do
    url "http://ftpmirror.gnu.org/aspell/dict/sc/aspell5-sc-1.0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/sc/aspell5-sc-1.0.tar.bz2"
    sha256 "591ae22f712b472182b41b8bc97dce1e5ecd240c75eccc25f59ab15c60be8742"
  end

  option "with-lang-sk", "Install sk dictionary"
  resource "sk" do
    url "http://ftpmirror.gnu.org/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2"
    sha256 "c6a80a2989c305518e0d71af1196b7484fda26fe53be4e49eec7b15b76a860a6"
  end

  option "with-lang-sl", "Install sl dictionary"
  resource "sl" do
    url "http://ftpmirror.gnu.org/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2"
    sha256 "e566d127f7130da2df7b1f4f4cb4bc51932517b0c24299f84498ba325e6133d1"
  end

  option "with-lang-sr", "Install sr dictionary"
  resource "sr" do
    url "http://ftpmirror.gnu.org/aspell/dict/sr/aspell6-sr-0.02.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/sr/aspell6-sr-0.02.tar.bz2"
    sha256 "705e58fb390633c89c4cb224a1cfb34e67e09496448f7adc6500494b6e009289"
  end

  option "with-lang-sv", "Install sv dictionary"
  resource "sv" do
    url "http://ftpmirror.gnu.org/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2"
    sha256 "9b70573c9c8cf76f5cdb6abcdfb834a754bbaa1efd7d6f57f47b8a91a19c5c0a"
  end

  option "with-lang-sw", "Install sw dictionary"
  resource "sw" do
    url "http://ftpmirror.gnu.org/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2"
    sha256 "7ed51f107dc57a7b3555f20d1cee2903275d63e022b055ea6b6409d9e081f297"
  end

  option "with-lang-ta", "Install ta dictionary"
  resource "ta" do
    url "http://ftpmirror.gnu.org/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2"
    sha256 "52f552f1a2c0fc53ed4eac75990ff75bccf3d5f1440ca3d948d96eafe5f3486a"
  end

  option "with-lang-te", "Install te dictionary"
  resource "te" do
    url "http://ftpmirror.gnu.org/aspell/dict/te/aspell6-te-0.01-2.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/te/aspell6-te-0.01-2.tar.bz2"
    sha256 "3682638a757a65afcc770e565e68347e8eb7be94052d9d6eff64fc767e7fec5d"
  end

  option "with-lang-tet", "Install tet dictionary"
  resource "tet" do
    url "http://ftpmirror.gnu.org/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2"
    sha256 "9dd546c9c48f42085e3c17f22c8e6d46e56f3ea9c4618b933c642a091df1c09e"
  end

  option "with-lang-tk", "Install tk dictionary"
  resource "tk" do
    url "http://ftpmirror.gnu.org/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2"
    sha256 "86f24209cab61a54ed85ad3020915d8ce1dec13fbfe012f1bf1d648825696a0b"
  end

  option "with-lang-tl", "Install tl dictionary"
  resource "tl" do
    url "http://ftpmirror.gnu.org/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2"
    sha256 "48b65d2c6886f353d1e1756a93bcd4d8ab2b88b021176c25dfdb5d8bcf348acd"
  end

  option "with-lang-tn", "Install tn dictionary"
  resource "tn" do
    url "http://ftpmirror.gnu.org/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2"
    sha256 "41a0c20e1d2acaa28a647d74b40778e491815566019f79e7049621f40d3bbd60"
  end

  option "with-lang-tr", "Install tr dictionary"
  resource "tr" do
    url "http://ftpmirror.gnu.org/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2"
    sha256 "0bc6530e5eebf8b2b53f1e8add596c62099173f62b9baa6b3efaa86752bdfb4a"
  end

  option "with-lang-uk", "Install uk dictionary"
  resource "uk" do
    url "http://ftpmirror.gnu.org/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2"
    sha256 "35f9a7e840c1272706bc6dd172bc9625cbd843d021094da8598a6abba525f18c"
  end

  option "with-lang-uz", "Install uz dictionary"
  resource "uz" do
    url "http://ftpmirror.gnu.org/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2"
    sha256 "2281c1fc7fe2411f02d25887c8a68eaa2965df3cd25f5ff06d31787a3de5e369"
  end

  option "with-lang-vi", "Install vi dictionary"
  resource "vi" do
    url "http://ftpmirror.gnu.org/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2"
    sha256 "3cd85d53bb62b0d104cb5c03e142c3bbe1ad64329d7beae057854816dc7e7c17"
  end

  option "with-lang-wa", "Install wa dictionary"
  resource "wa" do
    url "http://ftpmirror.gnu.org/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2"
    sha256 "5a17aa8aa37afbcc8f52336476670b93cba16462bcb89dd46b80f4d9cfe73fe4"
  end

  option "with-lang-yi", "Install yi dictionary"
  resource "yi" do
    url "http://ftpmirror.gnu.org/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2"
    sha256 "9879d35a5b0b86f8e217601568480f2f634bc8b7a97341e9e80b0d40a8202856"
  end

  option "with-lang-zu", "Install zu dictionary"
  resource "zu" do
    url "http://ftpmirror.gnu.org/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2"
    sha256 "3fa255cd0b20e6229a53df972fd3c5ed8481db11cfd0347dd3da629bbb7a6796"
  end

  option "with-all-langs", "Install all available dictionaries"
  deprecated_option "all" => "with-all-langs"

  fails_with :llvm do
    build 2334
    cause "Segmentation fault during linking."
  end

  def available_languages
    resources.map(&:name)
  end

  # const problems with llvm: http://www.freebsd.org/cgi/query-pr.cgi?pr=180565&cat=
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    ENV.prepend_path "PATH", bin

    languages = []

    available_languages.each do |lang|
      languages << lang if build.with? "lang-#{lang}"
    end

    if build.with? "all-langs"
      languages.concat(available_languages)
    elsif languages.empty?
      languages << "en"
    end

    languages.each do |lang|
      resource(lang).stage do
        system "./configure", "--vars", "ASPELL=#{bin}/aspell", "PREZIP=#{bin}/prezip"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal shell_output("echo \"misspell worrd\" | #{bin}/aspell list -d en_US").strip,
                 "worrd"
  end
end

__END__
diff --git a/interfaces/cc/aspell.h b/interfaces/cc/aspell.h
index 9c8e81b..2cd00d4 100644
--- a/interfaces/cc/aspell.h
+++ b/interfaces/cc/aspell.h
@@ -237,6 +237,7 @@ void delete_aspell_can_have_error(struct AspellCanHaveError * ths);
 /******************************** errors ********************************/


+#ifndef __cplusplus
 extern const struct AspellErrorInfo * const aerror_other;
 extern const struct AspellErrorInfo * const aerror_operation_not_supported;
 extern const struct AspellErrorInfo * const   aerror_cant_copy;
@@ -322,6 +323,7 @@ extern const struct AspellErrorInfo * const   aerror_missing_magic;
 extern const struct AspellErrorInfo * const   aerror_bad_magic;
 extern const struct AspellErrorInfo * const aerror_expression;
 extern const struct AspellErrorInfo * const   aerror_invalid_expression;
+#endif


 /******************************* speller *******************************/
