class TidyHtml5 < Formula
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/tag-4.9.25.tar.gz"

  depends_on "cmake" => :build

  def install
    ENV.deparallelize
    cd "build/cmake"
    system "cmake", "../..", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end
end
