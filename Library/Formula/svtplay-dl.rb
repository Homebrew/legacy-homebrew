class SvtplayDl < Formula
  desc "Download videos from http://svtplay.se"
  homepage "https://svtplay-dl.se"
  url "https://pypi.python.org/packages/source/s/svtplay-dl/svtplay-dl-0.20.2015.11.29.tar.gz"
  sha256 "7f93734da5c80387f354ccfa6cdd73af7a54978ac65ca65b1a29c801ac6dd685"

  bottle :unneeded

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
