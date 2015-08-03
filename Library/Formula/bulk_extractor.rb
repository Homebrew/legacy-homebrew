class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"

  bottle do
    cellar :any
    sha1 "f1bca8f9e8110bae172f7d1911fdd03439fb1dfa" => :mavericks
    sha1 "ff6c35229ec49ac068f1d3aafcad84b03125ad07" => :mountain_lion
    sha1 "027a6f08f3f50a615bfbfe3fbf9e3df5b33f6c3d" => :lion
  end

  depends_on "afflib" => :optional
  depends_on "boost"
  depends_on "exiv2" => :optional
  depends_on "libewf" => :optional

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

    assert (output_dir/"url.txt").read.include?("http://brew.sh")
    assert (output_dir/"telephone.txt").read.include?("(201)555-1212")
  end
end
