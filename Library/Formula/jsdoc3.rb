class Jsdoc3 < Formula
  homepage "http://usejsdoc.org/"
  head "https://github.com/jsdoc3/jsdoc.git"
  url "https://github.com/jsdoc3/jsdoc/archive/v3.2.2.tar.gz"
  sha1 "69d284a65a9b2b06c6e6454acb30976b41dea7b6"

  devel do
    url "https://github.com/jsdoc3/jsdoc/archive/v3.3.0-alpha13.tar.gz"
    sha1 "7f0d094c8e61bbc0fbbf965209e8fe1d903352d4"
    version "3.3.0-alpha13"
  end

  conflicts_with "jsdoc-toolkit", :because => "both install jsdoc"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"jsdoc"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
      /**
       * Represents a formula.
       * @constructor
       * @param {string} name - the name of the formula.
       * @param {string} version - the version of the formula.
       **/
      function Formula(name, version) {}
    EOS

    system "#{bin}/jsdoc", "--verbose", "test.js"
  end
end
