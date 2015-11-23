class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "http://s3tools.org/s3cmd"
  url "https://downloads.sourceforge.net/project/s3tools/s3cmd/1.6.0/s3cmd-1.6.0.tar.gz"
  sha256 "04279ee26c661d4b740449460ed93a74ffec91616f685474beea97e930fdfa5c"
  head "https://github.com/s3tools/s3cmd.git"

  depends_on :python if MacOS.version <= :snow_leopard

  bottle do
    cellar :any_skip_relocation
    sha256 "58fa4ec60a22a4fd19d4010338b59c73d42c6955e93db7bd92a708d2f561c296" => :el_capitan
    sha256 "0e3c657e20a641b22a820df361b72f29b7e5a17679b0d3c92330a567997f5872" => :yosemite
    sha256 "6520b7dd32b5cf7b48ac054d65706b4be6359e562dee84eb0337c2cc2780a24d" => :mavericks
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.0.tar.gz"
    sha256 "439df33ce47ef1478a4f4765f3390eab0ed3ec4ae10be32f2930000c8d19f417"
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
