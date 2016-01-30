class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "42eaa763988659fbb7e52a16fb700439a16a229be1d828d425717b3aabf121c5" => :el_capitan
    sha256 "9fca86e7c8248902b09f05b5ed046c3a0347afcabe2afc5a72de1619d211cc41" => :yosemite
    sha256 "b4928062ab8c39d082a9dbba713f4e0e3e460d2c111af0c39981eeba3d1d7638" => :mavericks
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
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]

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
