require 'formula'

def install_language_data
  langs = {
    'eng'     => '989ed4c3a5b246d7353893e466c353099d8b73a1',
    'heb'     => '67e10e616caf62545eacd436e85f89436687e22b',
    'hin'     => '4ceef97ffb8b4ab5ac79ee4bad5b5be0885f228f',
    'ara'     => 'e15cf6b7a027454db56ecedab0038c7739ab29cc',
    'tha'     => '04a35c04585a887662dc668e54f5368dabf31f50'
  }

  langs.each do |lang, sha|
    klass = Class.new(Formula) do
      url "http://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.#{lang}.tar.gz"
      version '3.02'
      sha1 sha
    end

    klass.new.brew { mv Dir['tessdata/*'], "#{share}/tessdata/" }
  end

  # pre-3.01 language data uses a different URL format and installs differently
  langs_old = {
    'chr'       => 'e49b17bb73911926050d45832171a54ab1d1f34c',
    'deu-frak'  => '5651562e0d944b5b89cc5977d71482089f12669f',
    'swe-frak'  => '22220ad4303ebe290e4e71170e96b488e81a7f1a',
    'chi_tra'   => 'a9798de7e068d85613602aa33a153da721aadc82',
    'chi_sim'   => '35f0254f159edeed509ec1e0779073bf998b6cdb',
    'ind'       => 'f4214ce40c5f6ef92085a8a45e9ff03f7cf7afca',
    'swe'       => '55291e8ea664155ad51db867284c11ad1a1c5d00',
    'ron'       => 'c20c73a2e17f5fe692de0fe9ac681da3984229ae',
    'slv'       => 'fbe464cd49d6a7495e6d95600d421aa2dd0b9d77',
    'srp'       => '47afc601b62998e4cc3f7403d846ba861f30b416',
    'tgl'       => '153ba1d0ddd209e1581d81d42fe5346f748e2f27',
    'tur'       => 'a01da62f3830833b258e2d46ce0f2852571470e6',
    'hun'       => '32ecad03877a841fbc0cb31c269214640008d604',
    'fin'       => '004d74d13f7b53cbefb86e2ba12bc67dce81d936',
    'ita'       => 'c166ba79256f6e7c1b993b2db7403d794131fe05',
    'nld'       => 'f7e3d46b1747a19158ac0797e859b65c56b5045f',
    'nor'       => 'fb65dede5fbe120823ecdcb0c6cbd1222ae7e245',
    'jpn'       => '6d605eee29e76fb841924916bd34095bbbbc45c0',
    'vie'       => '9158748a63afe87e4e25b5f32c222555f2ad8417',
    'spa'       => '7b30950749e84891fdef5f89409c3cf1b6418cd3',
    'ukr'       => '06ceebfd91fa473d6d91f8a2856c66733bea0131',
    'fra'       => '8d698bb3b659e862b3274970a57b3214de76f1ff',
    'slk'       => '16207e26d53504f98a7b1fadcb873dc4611149ec',
    'kor'       => '37bcd8110a426714f54d99f58b30104b3014ce5a',
    'ell'       => 'b7a449fc320cc579a729c0352e5cc642f565e64e',
    'rus'       => '2740accefc45e4ae004269ccb195948b8037a583',
    'por'       => '883e5e1fa1d991ef6d202951ee9d26a71db181dc',
    'bul'       => 'a9efae5e347a36ea90bd2ad357e732ad4da47fd3',
    'lav'       => 'b4efd308e725d743884f2984f804c82dd5382f63',
    'lit'       => '7adbe396a281c0f87c0b95da7e84b5b6029e3dbd',
    'pol'       => 'a303fc31b4b60532b01b4ccdc838f02ff0113f27',
    'dan-frak'  => 'c0eba6d3ca688a04fd8e3ce45fdbbf20e8e67d45',
    'deu'       => 'c4b3ecde18ce9f114faba88cdfd0308f90801266',
    'dan'       => 'bfac9c00d28fc4b19034c2098d41087a173084ae',
    'ces'       => 'dbec19aa23f42a08e6b195a96e64b443f7519620',
    'cat'       => '0301a9c81c1d646bd1b135ca89476fb63bd634f8'
  }

  langs_old.each do |lang, sha|
    klass = Class.new(Formula) do
      url "http://tesseract-ocr.googlecode.com/files/#{lang}.traineddata.gz",
        :using => GzipOnlyDownloadStrategy
      version '3.00'
      sha1 sha
    end

    klass.new.brew { mv Dir['*'], "#{share}/tessdata/" }
  end

end

# This stays around for the English-only build option
class TesseractEnglishData < Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.eng.tar.gz'
  version '3.02'
  sha1 '989ed4c3a5b246d7353893e466c353099d8b73a1'
end

class Tesseract < Formula
  homepage 'http://code.google.com/p/tesseract-ocr/'
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02.tar.gz'
  sha1 'a950acf7b75cf851de2de787e9abb62c58ca1827'

  option "all-languages", "Install recognition data for all languages"

  depends_on 'libtiff'
  depends_on 'leptonica'

  fails_with :llvm do
    build 2206
    cause "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc"
  end

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV['LIBLEPT_HEADERSDIR'] = HOMEBREW_PREFIX/"include"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    if build.include? "all-languages"
      install_language_data
    else
      TesseractEnglishData.new.brew { mv Dir['tessdata/*'], "#{share}/tessdata/" }
    end
  end

  def caveats; <<-EOF.undent
    Tesseract is an OCR (Optical Character Recognition) engine.

    The easiest way to use it is to convert the source to a Grayscale tiff:
      `convert source.png -type Grayscale terre_input.tif`
    then run tesseract:
      `tesseract terre_input.tif output`
    EOF
  end
end
