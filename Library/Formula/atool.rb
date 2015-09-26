class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "http://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"

  bottle do
    cellar :any
    sha1 "5bae1ea5b44d870cf9181ed061fe9ff2bb96351e" => :yosemite
    sha1 "886601266294c7e337f0f75f3b04c09a60590807" => :mavericks
    sha1 "22b2f19cfa180dd72929e5fb43d1444a206e660a" => :mountain_lion
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
    assert output.include? "example.txt"
    assert output.include? "example2.txt"
  end
end
