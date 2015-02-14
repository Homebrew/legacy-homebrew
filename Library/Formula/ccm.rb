class Ccm < Formula
  homepage "https://github.com/pcmanus/ccm"
  url "https://github.com/pcmanus/ccm/archive/ccm-2.0.2.tar.gz"
  sha1 "d6fc0d5b5640f16c08919308c0ab4298bfb90823"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any
    sha1 "ac55457ea11b2c831affdaf892133ce4edea8f8f" => :mavericks
    sha1 "de6894cdeb6067294f7dc184cd67acbda1727e44" => :mountain_lion
    sha1 "7f7178f0b6901a756fbcddaa4450902bc5390dae" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha1 "ddf58b3a0e699e142586b67097e3ae062766f11d"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[six psutil pyyaml].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match /Usage/, shell_output("#{bin}/ccm; 2>&1")
  end
end
