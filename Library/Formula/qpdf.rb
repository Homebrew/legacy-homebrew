class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "http://qpdf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/6.0.0/qpdf-6.0.0.tar.gz"
  sha256 "a9fdc7e94d38fcd3831f37b6e0fe36492bf79aa6d54f8f66062cf7f9c4155233"

  bottle do
    cellar :any
    sha256 "de523886e15f79209dbe270043dc252ebd2856649ac94f98141f37c3436ed20e" => :el_capitan
    sha256 "d352cf417a9ee038157343f138ff3f341e5aa5d9e91757c3ce88950b4509aba3" => :yosemite
    sha256 "f7059fb9d944230b06ad8ddb34528e4090161ee0a3ddee7068a86046c61d4b04" => :mavericks
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
