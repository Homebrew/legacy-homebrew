class Googlecl < Formula
  homepage 'https://code.google.com/p/googlecl/'
  url 'https://googlecl.googlecode.com/files/googlecl-0.9.14.tar.gz'
  sha1 '810b2426e2c5e5292e507837ea425e66f4949a1d'

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with 'osxutils', :because => 'both install a google binary'

  resource "gdata" do
    url "https://pypi.python.org/packages/source/g/gdata/gdata-2.0.18.tar.gz"
    sha1 "4cd6804f2af81697219307421996c6055c7c16e4"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("gdata").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/google", "help", "docs"
  end
end
