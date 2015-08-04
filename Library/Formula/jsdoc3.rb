class Jsdoc3 < Formula
  desc "Inline API documentation processor for JavaScript"
  homepage "http://usejsdoc.org/"
  head "https://github.com/jsdoc3/jsdoc.git"
  url "https://github.com/jsdoc3/jsdoc/archive/v3.2.2.tar.gz"
  sha256 "c101896d2cf08be636332a5eaaf38fe318ae7f639c37735abd1643b1b973254b"

  devel do
    url "https://github.com/jsdoc3/jsdoc/archive/3.3.0-beta3.tar.gz"
    sha256 "de32d538a5eb1835fdafbb686cdab7ea80ad64b3651a0b85904766c2f5e94b44"
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
