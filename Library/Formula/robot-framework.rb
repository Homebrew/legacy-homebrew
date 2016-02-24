class RobotFramework < Formula
  desc "Open source test automation framework for acceptance testing"
  homepage "http://robotframework.org/"
  url "https://github.com/robotframework/robotframework/archive/3.0.tar.gz"
  sha256 "1b830fa5e4470ff6b2d404bd99b357cfce4a2abd15c255373045a77d44e517a5"

  head "https://github.com/robotframework/robotframework.git", :branch => "master"
  depends_on :x11
  depends_on :python if MacOS.version <= :snow_leopard

  resource "selenium" do
    url "https://pypi.python.org/packages/source/s/selenium/selenium-2.49.1.tar.gz"
    sha256 "5fcda19a6d546122bc868a5d36c8e3a40e2593c14b8a3123e5a911b0281fad47"
  end

  resource "robotframework-selenium2library" do
    url "https://pypi.python.org/packages/source/r/robotframework-selenium2library/robotframework-selenium2library-1.7.4.tar.gz"
    sha256 "4332e3021c6e4ba4a04f4dd99c4fb970315d9fc0fe31bcb62aad2fe833ad9400"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requests_kerberos" do
    url "https://pypi.python.org/packages/source/r/requests-kerberos/requests-kerberos-0.8.0.tar.gz"
    sha256 "f3ce6e70e19080fe146245f1c663e73a3868fbb087142962b91c5396fa051b1a"
  end

  def install
    vendor_site_packages = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"HelloWorld.txt").write <<-EOF.undent
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOF

    (testpath/"HelloWorld.py").write <<-EOF.undent
      def hello_world():
          print "HELLO WORLD!"
    EOF
    system bin/"pybot", testpath/"HelloWorld.txt"
  end
end
