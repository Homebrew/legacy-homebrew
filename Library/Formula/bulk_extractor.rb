class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 1

  bottle do
    cellar :any
    sha256 "ed6cd0603df49a8158e02fa3e4e3edc10998314fc914e6441e33dd578451996e" => :yosemite
    sha256 "07dfbefa2dda0b17f587febe7da274c1f8eb62b7c3c5c9655b85debb1f282d71" => :mavericks
    sha256 "32545b00c77303269a7488641005aeac27145f6e1eb8f6182fe91e14347be228" => :mountain_lion
  end

  depends_on "afflib" => :optional
  depends_on "boost"
  depends_on "exiv2" => :optional
  depends_on "libewf" => :optional
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # Install documentation
    (share/"bulk_extractor/doc").install Dir["doc/*.{html,txt,pdf}"]

    (lib/"python2.7/site-packages").install Dir["python/*.py"]

    # Install the GUI the Homebrew way
    # .jar gets installed into bin by default
    libexec.install bin/"BEViewer.jar"
    (bin/"BEViewer").unlink
    bin.write_jar_script libexec/"BEViewer.jar", "BEViewer", "-Xmx1g"
  end

  test do
    input_file = testpath/"data.txt"
    input_file.write "http://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system "#{bin}/bulk_extractor", "-o", output_dir, input_file

    assert_match "http://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end
