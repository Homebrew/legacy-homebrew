class Miller < Formula
  desc "Miller is like sed, awk, cut, join, and sort for name-indexed data such as CSV."
  homepage "http://johnkerl.org/miller/"
  url "https://github.com/johnkerl/miller/archive/v2.1.3.tar.gz"
  sha256 "feb246c1a199e9a18c9ec630ddc021fca4ba9f1bf55286bf03018570b81e760c"

  depends_on "asciidoc"

  def install
    ENV.deparallelize

    cd "c" do
      system "make", "mlr"
    end
    system "make", "manpage", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    man1.install "doc/miller.1"
    bin.install "c/mlr"
  end

  test do
    system "#{bin}/mlr"
  end
  test do
    (testpath/"test.dkvp").write <<-EOS.undent
      first_name=John,last_name=Kerl,description="Miller author"
      first_name=Max,last_name=Howell,description="Homebrew author"
    EOS
    output = shell_output("#{bin}/mlr --ocsv cat test.dkvp")
    assert_equal output.gsub(/\r\n/, "\n"), <<-EOS.undent
      first_name,last_name,description
      John,Kerl,"Miller author"
      Max,Howell,"Homebrew author"
    EOS
  end
end
