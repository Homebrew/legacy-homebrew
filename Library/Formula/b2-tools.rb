class B2Tools < Formula
  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.4.4.tar.gz"
  sha256 "43a0edf1b0260b0231e0a80b2cedc2a740b8f0388084a2b04aa8a70074f740e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0980b12bbf18f4b71a681dccdf275dd7a22e5523421a3f31767fbf99ed799b8a" => :el_capitan
    sha256 "e919fdec20bee0c12ce7223de650a2b0075b5875543ce105dff56f1b8fb340db" => :yosemite
    sha256 "b8a315f86ca11dd7758c12808e1501278f6fbd70a31ac1695c67beb097e0f1f2" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
  end

  test do
    assert_match "bad_auth_token",
      shell_output("#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY", 1)
  end
end
