class Xlslib < Formula
  desc "C++/C library to construct Excel .xls files in code"
  homepage "https://sourceforge.net/projects/xlslib"
  url "https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.5.0.zip"
  mirror "https://dl.bintray.com/homebrew/mirror/xlslib-package-2.5.0.zip"
  sha256 "05a5d052ffdd6590755949d80d16a56285561557bc9a5e887e3b8b3fef92a3f3"

  bottle do
    cellar :any
    revision 2
    sha256 "4eec9d433ab0e89aedf4fa6ccaf7d9be555519c574a4c0cd1cd2cd80a57eab77" => :el_capitan
    sha256 "41398d8c2e6c8349ea752eb0d2d9cdbc560ec43cb91e0622b786a2b28d6341de" => :yosemite
    sha256 "a984b3016532ffaeee04cffb60b19e61aa44ab70ad4fcf91a6f8daa87319e744" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    cd "xlslib"
    system "autoreconf", "-i" # shipped configure hardcodes automake-1.13
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
