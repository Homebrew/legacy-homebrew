class Mkdocs < Formula
  desc "Project documentation with Markdown"
  homepage "http://www.mkdocs.org/"
  url "https://github.com/mkdocs/mkdocs/archive/0.15.3.tar.gz"
  sha256 "a5442ae24fd9e6f9daeefaf354c960e5dac27ff388f63e1bb324ed8a1b7edaa9"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2015.11.20.1.tar.gz"
    sha256 "30b0a7354a1b32caa8b4705d3f5fb2dadefac7ba4bf8af8a2176869f93e38f16"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "backports.ssl-match-hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "mkdocs-bootswatch" do
    url "https://pypi.python.org/packages/source/m/mkdocs-bootswatch/mkdocs-bootswatch-0.3.1.tar.gz"
    sha256 "1ba4761b0739786b3fb6baeaa3fc483788e5b3ba30c4a6514019a0db6f4623d0"
  end

  resource "mkdocs-bootstrap" do
    url "https://pypi.python.org/packages/source/m/mkdocs-bootstrap/mkdocs-bootstrap-0.1.1.tar.gz"
    sha256 "15084a6be59393fe5ecb9f04d09e674337a69fbd1e6ec5d9328e606a6c6cab36"
  end

  resource "livereload" do
    url "https://pypi.python.org/packages/source/l/livereload/livereload-2.4.1.tar.gz"
    sha256 "887cc9976d72d7616fa57c82c4ef5bf5da27e2350dfd6f65d3f44e86efc51b92"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.3.tar.gz"
    sha256 "b720d9faabe193287b71e3c26082b0f249501288e153b7e7cfce3bb87ac8cc1c"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.5.tar.gz"
    sha256 "8d94cf6273606f76753fcb1324623792b3738c7612c2b180c85cc5e88642e560"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<-EOS.undent
      site_name: MkLorum
      pages:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<-EOS.undent
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end
