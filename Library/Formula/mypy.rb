class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/JukkaL/mypy/archive/v0.2.0.tar.gz"
  sha256 "0c24f50509bdf3e0d9bd386a08ef4f11ee0114e1f5a9b2afeacbf9561cf022c1"
  head "https://github.com/JukkaL/mypy.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cc2780459f9cbb98805a0873ca7c5e6286bfad54545ba8d6898c663658867fea" => :yosemite
    sha256 "2c5872aed4f6c1fe965bb6962f448e47d412930bc270e4fbfc50427a094b3a23" => :mavericks
    sha256 "6a67aefdf446d5600f06aa0f7e9de8c79a7165cb73edfbd6e2dd73aba072ff73" => :mountain_lion
  end

  option "without-docs", "Don't build documentation"

  depends_on :python3

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha256 "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "rtd_theme" do
    url "https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-0.1.7.tar.gz"
    sha256 "9a490c861f6cf96a0050c29a92d5d1e01eda02ae6f50760ad5c96a327cdf14e8"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"sphinx/lib/python#{pyver}/site-packages"
      %w[docutils pygments jinja2 markupsafe sphinx].each do |r|
        resource(r).stage do
          system "python3", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end

      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
      %w[rtd_theme].each do |r|
        resource(r).stage do
          system "python3", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end

      ENV.prepend_path "PATH", buildpath/"sphinx/bin"
      cd "docs" do
        system "make", "html"
        doc.install Dir["build/html/*"]
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    pyver = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{pyver}/site-packages"

    (testpath/"broken.py").write <<-EOS.undent
      def p() -> None:
        print ('hello')
      a = p()
    EOS

    expected_error = /line 3: "p" does not return a value/
    assert_match expected_error, pipe_output("#{bin}/mypy #{testpath}/broken.py 2>&1")
    system "python3", "-c", "import typing"
  end
end
