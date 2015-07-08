class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "http://www.gnu.org/software/recutils/"
  url "http://ftpmirror.gnu.org/recutils/recutils-1.7.tar.gz"
  mirror "http://ftp.gnu.org/gnu/recutils/recutils-1.7.tar.gz"
  sha1 "20d265aecb05ca4e4072df9cfac08b1392da6919"

  bottle do
    cellar :any
    sha1 "e8d589aeea32e80a0f8eff4e51e1a2003ee98595" => :yosemite
    sha1 "7aeab12cf02e49d18cbd345125b9dd8945120b64" => :mavericks
    sha1 "4569539ec11801311371fbc9a60f25e20815d4a9" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      a,b,c
      1,2,3
    EOS
    system "#{bin}/csv2rec", "test.csv"
  end
end
