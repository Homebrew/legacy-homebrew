class SvtplayDl < Formula
  desc "Download videos from http://svtplay.se"
  homepage "https://svtplay-dl.se"
  url "https://pypi.python.org/packages/source/s/svtplay-dl/svtplay-dl-0.20.2015.11.29.tar.gz"
  sha256 "7f93734da5c80387f354ccfa6cdd73af7a54978ac65ca65b1a29c801ac6dd685"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b26888e8aedd32827e2caa6ffcdeb2c115261662409dc0daf7ef2d6b4a842dc" => :el_capitan
    sha256 "dc6e349be3fc0dd8ff7a396b0e7e2c480613af46a8c1643cff5a0bd5bfea59c8" => :yosemite
    sha256 "1be2a31d2ce11561b486129ba2a2d6cf087d7126f02a91bb350c4d7a790c57b6" => :mavericks
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.8.1.tar.gz"
    sha256 "84fe8d5bf4dcdcc49002446c47a146d17ac10facf00d9086659064ac43b6c25b"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  depends_on "rtmpdump"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[requests].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
