class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "https://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "dcfdcb720aa3704b9103aa01bb8efac42d24327bc8664baa420a9a69d75a98b6" => :el_capitan
    sha256 "efdeeb165e146f4a76477417d2af9c60e2f776d06081bb579ff73ceb296a899d" => :yosemite
    sha256 "4eed286344a3a1d4fc6efc908b34062b5cc7c7fdf2449cf85b7767168585fc7a" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "apple_juice"
    cd testpath/"apple_juice" do
      touch "example.txt"
      touch "example2.txt"
      system bin/"apack", "test.tar.gz", "example.txt", "example2.txt"
    end
    output = shell_output("#{bin}/als #{testpath}/apple_juice/test.tar.gz")
    assert_match "example.txt", output
    assert_match "example2.txt", output
  end
end
