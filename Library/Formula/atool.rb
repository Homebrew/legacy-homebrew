class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "https://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e7f2a05c1ace127074412298599ca5a195f523e116adcf1235bb1002b9f1c43f" => :el_capitan
    sha256 "edc0be06f8072965a398708ffa59319d7663f5f4cb3bfd7585ffd5b8239231a5" => :yosemite
    sha256 "f027ccef0bdaa3f6754810aa8ada837ef136be2bf118eae9815c056f5f5bcc4d" => :mavericks
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
