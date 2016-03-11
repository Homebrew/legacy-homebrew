class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "http://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.6.tar.xz"
  sha256 "df54271492070fbcc6aad9f81ca89658b25dd106cc4ab6b04b067b7a43dcc078"

  bottle do
    sha256 "f464e2657607f9ad9701f12a1aa820fc91d8f1f5c119913b6f0aaf50baf44bf4" => :el_capitan
    sha256 "b37902dfeed5ef199c969d51aafef47ca88d4a4f63862e10f95aa002ef15427d" => :yosemite
    sha256 "87b99a5d084d752b4f4d53f63f7bcbdb6908a5b21a37eb021e16f1b5c3b5e4da" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "gnu-sed" => :build
  depends_on "librevenge"
  depends_on "glm"
  depends_on "mdds"

  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.5.8.tar.bz2"
    sha256 "08e2f64bfe3f750be7391eb0af53967e164b628c59f02be4d83789eb4f036eaa"
  end

  def install
    resource("liblangtag").stage do
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./configure", "--prefix=#{libexec}", "--enable-modules=no"
      system "make"
      system "make install"
    end

    ENV["LANGTAG_CFLAGS"] = "-I#{libexec}/include"
    ENV["LANGTAG_LIBS"] = "-L#{libexec}/lib -llangtag -lxml2"
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libetonyek/EtonyekDocument.h>
      int main() {
        return libetonyek::EtonyekDocument::RESULT_OK;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libetonyek-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-letonyek-0.1"
    system "./test"
  end
end
