class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "http://s3tools.org/s3cmd"
  url "https://downloads.sourceforge.net/project/s3tools/s3cmd/1.6.1/s3cmd-1.6.1.tar.gz"
  sha256 "4675794f84d8744ee3d35873d180f41c7b2116895ccbe2738a9bc552e1cf214e"
  head "https://github.com/s3tools/s3cmd.git"

  depends_on :python if MacOS.version <= :snow_leopard

  bottle do
    cellar :any_skip_relocation
    sha256 "58fa4ec60a22a4fd19d4010338b59c73d42c6955e93db7bd92a708d2f561c296" => :el_capitan
    sha256 "0e3c657e20a641b22a820df361b72f29b7e5a17679b0d3c92330a567997f5872" => :yosemite
    sha256 "6520b7dd32b5cf7b48ac054d65706b4be6359e562dee84eb0337c2cc2780a24d" => :mavericks
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "python-magic" do
    url "https://pypi.python.org/packages/source/p/python-magic/python-magic-0.4.10.tar.gz"
    sha256 "79fd2865ec96074749825f9e9562953995d5bf12b6793f24d75c37479ad4a2c3"
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
