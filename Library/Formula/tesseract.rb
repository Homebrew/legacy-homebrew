class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/3.04.00.tar.gz"
  sha256 "7e6e48b625e1fba9bc825a4ef8c39f12c60aae1084939133b3c6a00f8f8dc38c"

  bottle do
    revision 1
    sha256 "19d4caa5ce632ca41d3b45accd7f116f6cf93688531f26437cb4833f26cc0172" => :yosemite
    sha256 "092e7e8ccc7622a48a3103d259c9770638fff086438fd5f82661fc80144e4705" => :mavericks
    sha256 "3bac833b02c9927cf4ba9ef43be39ce017f57a5380a076568f79455a836e96e7" => :mountain_lion
  end

  head do
    url "https://github.com/tesseract-ocr/tesseract.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build

    resource "tessdata-head" do
      url "https://github.com/tesseract-ocr/tessdata.git"
    end
  end

  option "all-languages", "Install recognition data for all languages"

  depends_on "libtiff" => :recommended
  depends_on "leptonica"

  needs :cxx11

  fails_with :llvm do
    build 2206
    cause "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc"
  end

  resource "tessdata" do
    url "https://github.com/tesseract-ocr/tessdata/archive/3.04.00.tar.gz"
    sha256 "5dcb37198336b6953843b461ee535df1401b41008d550fc9e43d0edabca7adb1"
  end

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata/raw/3.04.00/eng.traineddata"
    sha256 "c0515c9f1e0c79e1069fcc05c2b2f6a6841fb5e1082d695db160333c1154f06d"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    if build.head?
      resource("tessdata-head").stage { mv Dir["*"], share/"tessdata" }
    elsif build.include? "all-languages"
      resource("tessdata").stage { mv Dir["*"], share/"tessdata" }
    else
      resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
      resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
    end
  end
end
