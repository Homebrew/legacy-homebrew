class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'https://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0/s3cmd-1.5.0.tar.gz'
  sha1 '53ebc485329cb15cad8f61ca0c8c2d06563ee2f3'
  head 'https://github.com/s3tools/s3cmd.git'

  depends_on :python if MacOS.version <= :snow_leopard

  bottle do
    cellar :any
    revision 2
    sha1 "5923f4a71ccc26ac8e4d603f667ea32cdddfe1ae" => :yosemite
    sha1 "0a6f4d5b585d618189ea7dd2f417583c818c75e9" => :mavericks
    sha1 "473b664c50c6673c4b14b92084780d350da36c51" => :mountain_lion
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
