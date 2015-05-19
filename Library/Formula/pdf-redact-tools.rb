class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/micahflee/pdf-redact-tools"
  url "https://github.com/micahflee/pdf-redact-tools/archive/v0.1.tar.gz"
  sha256 "9d5f095e5d056eb527c08c4736b45c99aa6399424dd6ed7155e3d7cd1600c55e"
  head "https://github.com/micahflee/pdf-redact-tools.git"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "imagemagick"
  depends_on "exiftool"
  depends_on "ghostscript"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Modifies the file in the directory the file is placed in.
    cp test_fixtures("test.pdf"), "test.pdf"
    system bin/"pdf-redact-tools", "-e", "test.pdf"
    assert File.exist?("test_pages/page-0.png")
    rm_rf "test_pages"

    system bin/"pdf-redact-tools", "-s", "test.pdf"
    assert File.exist?("test-final.pdf")
  end
end
