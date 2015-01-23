class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'https://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0/s3cmd-1.5.0.tar.gz'
  sha1 '53ebc485329cb15cad8f61ca0c8c2d06563ee2f3'
  head 'https://github.com/s3tools/s3cmd.git'

  depends_on :python if MacOS.version <= :snow_leopard

  bottle do
    cellar :any
    sha1 "254a78674d86587e18419099e20059c61b5a257a" => :yosemite
    sha1 "03ec4493b583447b5e0db95f8b98066866920ce8" => :mavericks
    sha1 "ec0dd6f3298c8b8aa5dab60e395d7c013a6747c9" => :mountain_lion
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.0.tar.gz"
    sha1 "159081a4c5b3602ab440a7db305f987c00ee8c6d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end
end
