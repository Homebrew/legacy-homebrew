class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "http://qpdf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/6.0.0/qpdf-6.0.0.tar.gz"
  sha256 "a9fdc7e94d38fcd3831f37b6e0fe36492bf79aa6d54f8f66062cf7f9c4155233"

  bottle do
    cellar :any
    revision 1
    sha256 "639b932db33ce4c284c3f3af0dd2d6d8c71a1715308bfe5a0ba47ea2cca92760" => :el_capitan
    sha256 "607067e2cc684611fe344a1d1bfb29f5d30aed55c8462968e98591fe19e02f78" => :yosemite
    sha256 "927c353822d0ae21b0d822931121c4ff36a2a0e2905dd04075c60de4d0b023bf" => :mavericks
  end

  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
