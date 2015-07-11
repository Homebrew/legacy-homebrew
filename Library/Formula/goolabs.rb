class Goolabs < Formula
  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://pypi.python.org/packages/source/g/goolabs/goolabs-0.2.0.tar.gz"
  sha1 "c544460b51ad63c7d79b0ef542816c2981fa22f9"
  revision 1

  bottle do
    cellar :any
    sha256 "b66b183f0a8ac370648b1c1a9a060be119b2f4dcd2579c9f7adb50c9467a3249" => :yosemite
    sha256 "bd2d16c7d34b8d923e6d68356158e8a46b5266463a0e30ad557a133960efd0ff" => :mavericks
    sha256 "6afbdf9a7c5caacc02463f7e8e8688359912112118ed8baf23dc38c3845b0c90" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha1 "ae85a5546ce42642dc63b2645f4732189d253bb6"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha1 "6db8805632521a13789161bccb14f761672ec46f"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    res = %w[six click requests]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
