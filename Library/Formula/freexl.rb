class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.2.tar.gz"
  sha256 "b39a4814a0f53f5e09a9192c41e3e51bd658843f770399023a963eb064f6409d"

  bottle do
    cellar :any
    sha256 "5c6edd364f1c97cca352eba13ea5c594ec5bb4a1a2878b1ea187ec6728d72f31" => :el_capitan
    sha256 "8e7233c0b1c33adad45ef88a52e1e797aa677933b5348fe46cc99085a6975a7c" => :yosemite
    sha256 "04495f65384391622533b8fbe4c23579a3704ce4da491e3b7c53cb171c50c8c6" => :mavericks
    sha256 "ae6d78c69b399ea733ff6ef346d83499408c0c510fe40484072c423b9552925b" => :mountain_lion
  end

  option "without-check", "Skip compile-time make checks."

  depends_on "doxygen" => [:optional, :build]

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check" if build.with? "check"
    system "make", "install"

    if build.with? "doxygen"
      system "doxygen"
      doc.install "html"
    end
  end
end
