require "formula"

class Tesseract < Formula
  homepage 'http://code.google.com/p/tesseract-ocr/'
  url 'https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02.tar.gz'
  sha1 'a950acf7b75cf851de2de787e9abb62c58ca1827'
  revision 2

  bottle do
    sha1 "5949807031e5d1a5c4382ed93afa06e684be104f" => :mavericks
    sha1 "44298a87cc05b956cb9b8feb85559530cac02ad9" => :mountain_lion
    sha1 "5beafc2400bb170185c7934ed69749c9b8ef8c99" => :lion
  end

  head do
    url "http://tesseract-ocr.googlecode.com/svn/trunk"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on "pkg-config" => :build
  end

  option "all-languages", "Install recognition data for all languages"

  depends_on "libtiff" => :recommended
  depends_on "leptonica"

  fails_with :llvm do
    build 2206
    cause "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc"
  end

  # Version 3.02 language packages. Alphabetized by language code.
  LANGS = {
    "afr" => "fe8fa7f87d207024938abf6e143f6612cd6bbbc7",
    "ara" => "e15cf6b7a027454db56ecedab0038c7739ab29cc",
    "aze" => "8e26797471e9cd943ac76cd6803e596ed3fb0625",
    "bel" => "9fc3a081e077b23d8da253f227e8a337acd9a6c8",
    "ben" => "d1b2dec8ee537598594554768de899a9e8e361f6",
    "bul" => "34ef79f0f0f3f2b7715c343ea5357791e52336d8",
    "cat" => "1d806a2346100d93bcfc32ebf4b4c94ab006ef93",
    "ces" => "82f1797de7c06bfa9a20dbf2e4e1db03a0e94be0",
    "chi_sim" => "edcfd4cea1b5e52a37eed605c6a2d7d5e15ef03f",
    "chi_tra" => "f2c8bca5ffeb62e0a10d685d4f66a029472ffe52",
    "chr" => "b9ead6114a41b395a82f1d33a276d524af81f993",
    # this Danish package also contains Danish Fraktur language data
    "dan" => "b2c4c09cde1ac5229d22eff72accb60e66b09c2b",
    # this German package also contains German Fraktur language data
    "deu" => "6d21596225f9a4c36fa81b19518f2aead8c8ac79",
    "ell" => "5a5746c7a1e473c89de71a4dd46a8a888ba4ce76",
    "eng" => "989ed4c3a5b246d7353893e466c353099d8b73a1",
    "enm" => "8d83830859654ffb7e1228f6fbd2604aafea987f",
    "epo" => "84ff2e071864e2766dcde842cdbe74d6bdd59549",
    "epo_alt" => "e481f3e41c37dcf28786a90b9384321f8ca15eda",
    "equ" => "24b46c2bfe4a652b6ac7bdee9afb68f44ffc333e",
    "est" => "d37d2c295472f6e6ded26c9d799380d205a8cec4",
    "eus" => "072b7a4fc36c8b28903e9ef651693be702f21afd",
    "fin" => "c30b504178e5fabd8f084f59e72aa9579b4ee436",
    # this French package also contains fraktur for Danish, German, Slovakian
    "fra" => "627893d878b33138608df372d191bd799b0edd4f",
    "frk" => "81b897434eee2762757519097913bd02ba527dd1",
    "frm" => "e52f58b8244f67f07b3bc0f849247b79ab6d1bcb",
    "glg" => "dee1605b15a57b321e7ad747df6c12a9491cfb08",
    "grc" => "2502de7df524264959c73f7253c580f491ee9a2d",
    "heb" => "67e10e616caf62545eacd436e85f89436687e22b",
    "hin" => "4ceef97ffb8b4ab5ac79ee4bad5b5be0885f228f",
    "hrv" => "c281dbaca6c1fa39ab1e7a82b43542fa46a9020b",
    "hun" => "4d7b4534d03c1a6a3861dac0f66da13fd9601e62",
    "ind" => "364fe00da0be5bd47661a68acf10ac0bc928cdaf",
    "isl" => "7036d949d1860f192d4e038597c435d47fe8ca9a",
    # this Italian package also contains Old Italian language data
    "ita" => "b4d75234cab050db69874190d1bab5b2b1c59961",
    "jpn" => "7212a708ef688687538abe9a40aab99aa06017a2",
    "kan" => "d3a71631227b04dbcd370b1fdee6d423655663b7",
    "kor" => "d39e165fb73e339c21fbdf995b9d0fffda9fd7db",
    "lav" => "98fccc5c8b1613364d5386b29c9dfa82d178d772",
    "lit" => "1ef0fb76f9b463aa8a6e41056c87842d43102698",
    "mal" => "aadbded7e50f7dd503d62f99060836c9f4d65732",
    "mkd" => "f6a5235ad131dde816f3f151df4f999f4ea214c6",
    "mlt" => "72d4ee59e6fd79f618a7ef09bdedb5e887d20db4",
    "msa" => "6344682dc9fe541499f455ae88c07f5941d5e646",
    "nld" => "e68e491d68fa367e2d173b12f19330e3ed72e750",
    "nor" => "cc0f69a4df82adb0f8591f1dfbe3920ced46181b",
    "pol" => "b6c1092ad1bdba5dc019d8f84d3e6c3478e4ffb0",
    "por" => "919e6503bd7fc00ffeb27b0823ddad3d2aaf7ba9",
    "ron" => "159afd5da08a58ef2cc49be0166068d70c297384",
    "rus" => "5caa3f1c5d46642e7c0c17ecd7cc4fe2a4aa2b0b",
    # this Slovakian package also contains Slovakian Fraktur language data
    "slk" => "946d6033b276f7e3fcfceca35978d3380d10710f",
    "slv" => "cbd9506944069954e3742cbcac2f15ca7f7c90cc",
    # this Spanish package also contains Old Spanish language data
    "spa" => "51e1289f0320bd750be4b04065dcae6862562b01",
    "sqi" => "4d865da27ec2b0ce5f5dbc67a7a1781af1eca05c",
    "srp" => "ca496054260efb361f6873ba7212dd7438fd496c",
    "swa" => "453ca6cd1b0b154006eef2046fb008796f59ce8a",
    "swe" => "8ecabd4d010ff89d6d3975fb09fc622bf1c157bb",
    "tam" => "b1067548993f168b06019616fc1a1d515169ee84",
    "tel" => "726a411daa5ba3c5a6e3e04e870591ba65bf3ee8",
    "tgl" => "5437a1a2ffc3dceea2e241b41bd414e64148274d",
    "tha" => "04a35c04585a887662dc668e54f5368dabf31f50",
    "tur" => "017c11a1630ad96f600a863803a892aeadaa34fb",
    "ukr" => "729a2bd1a2cf81c314b8b0f2057260019f056149",
    "vie" => "9ab987ff577f1e1c536000d97cf6247f44ef8fdd"
  }

  LANGS.each do |name, sha|
    resource name do
      url "https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.#{name}.tar.gz"
      version "3.02" # otherwise "ocr" incorrectly detected as the version
      sha1 sha
    end
  end

  # Tesseract has not released the 3.02 version of the OSD traineddata, so we must download the 3.01 copy
  resource "osd" do
    url "https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.01.osd.tar.gz"
    version "3.01"
    sha1 "a559801a42be8a3dc15ae2ec27da99bd8b0b85ac"
  end

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    if build.include? "all-languages"
      resources.each { |r| r.stage { mv Dir["tessdata/*"], share/"tessdata" } }
    else
      resource("eng").stage { mv Dir["tessdata/*"], share/"tessdata" }
      resource("osd").stage { mv Dir["tessdata/*"], share/"tessdata" }
    end
  end
end
