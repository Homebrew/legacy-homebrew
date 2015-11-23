class Logentries < Formula
  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.19.tar.gz"
  sha256 "400765eef31ec7b453bb41f2fa31f8e6dda797561280af2e8feb643fde84a217"

  bottle do
    cellar :any
    sha256 "8615d925ca86af2271dd691aecacd56b9fcf06e02da8fd85d2df6ca1c046bb81" => :yosemite
    sha256 "26306f8ae96b9e5250e75a463db1c33666f87bb002dc3aea8bb9c3f05fc54b10" => :mavericks
    sha256 "c820319df665f263cf8b7a9190a4e79fdaaf46509d429a71362d81a2626b027b" => :mountain_lion
  end

  conflicts_with "le", :because => "both install a le binary"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
