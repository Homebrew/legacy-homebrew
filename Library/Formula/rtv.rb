class Rtv < Formula
  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.8.0.tar.gz"
  sha256 "90828ad016d669dfc162ff958124700abcce7f2cf1aedcf5be90fe97f4552764"

  depends_on :python3

  resource "decorator" do
    url "https://pypi.python.org/packages/source/d/decorator/decorator-4.0.6.tar.gz"
    sha256 "1c6254597777fd003da2e8fb503c3dbf3d9e8f8d55f054709c0e65be3467209c"
  end

  resource "update_checker" do
    url "https://pypi.python.org/packages/source/u/update_checker/update_checker-0.11.tar.gz"
    sha256 "681bc7c26cffd1564eb6f0f3170d975a31c2a9f2224a32f80fe954232b86f173"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "praw" do
    url "https://pypi.python.org/packages/source/p/praw/praw-3.3.0.zip"
    sha256 "dbd92207ed7b790e6d1a0b5150cc506ebfd5c84cb2cee182c0394d1f14d1489f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  resource "kitchen" do
    url "https://pypi.python.org/packages/source/k/kitchen/kitchen-1.2.4.tar.gz"
    sha256 "38f73d844532dba7b8cce170e6eb032fc07d0d04a07670e1af754bd4c91dfb3d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python3.5/site-packages"
    %w[update_checker decorator tornado praw six requests kitchen].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.5/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
