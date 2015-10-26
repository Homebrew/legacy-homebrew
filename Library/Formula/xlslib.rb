class Xlslib < Formula
  desc "C++/C library to construct Excel .xls files in code"
  homepage "https://sourceforge.net/projects/xlslib"
  url "https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.5.0.zip"
  mirror "https://dl.bintray.com/homebrew/mirror/xlslib-package-2.5.0.zip"
  sha256 "05a5d052ffdd6590755949d80d16a56285561557bc9a5e887e3b8b3fef92a3f3"

  bottle do
    cellar :any
    sha256 "a4d5714e19c1d4e44d67bbe9cda064120dc01e9cf207771ae5ef208e76ed2cd9" => :el_capitan
    sha256 "cfd77ea71da12276124cb9cb08bb9ad51ab38b17e912d4dd8c4fec8a428714a1" => :yosemite
    sha256 "b23da4149e9db9bf4152cfc8943ac83d254796d88741592949c3928ae7988149" => :mavericks
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
