class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "http://ci.openstack.org/jjb.html"
  url "https://pypi.python.org/packages/source/j/jenkins-job-builder/jenkins-job-builder-1.3.0.tar.gz"
  sha256 "dd74dc9673c1f18e41ccd83d6d78b21409375bc84981881bab62fd0f8dbb3b84"

  bottle do
    cellar :any
    sha256 "9e9619dbd6123e278cb939649ec874b7b6784c6c2a6e921367e2bb0d140c24cb" => :yosemite
    sha256 "0ebaeea8fe2d464b9f26fe7b6064e62a2d5e81d39e22a1090c4a317ff6fb5477" => :mavericks
    sha256 "e6a4404578fb17990d288758013e50e64e31306c74091eb7f79a3d1a4cd2b893" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "python-jenkins" do
    url "https://pypi.python.org/packages/source/p/python-jenkins/python-jenkins-0.4.8.tar.gz"
    sha256 "ec33a1b6d1b74350d84ccff05cf41d4fb2677fc63bac8a471db5038c67fcdd93"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.6.0.tar.gz"
    sha256 "4eaee8ff5544703edd1951ed1dc0b283da99a74f740d9f9055eeefcf329de1d1"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
    sha256 "ca047986f0528cfa975a14fb9f7f106271d4e0c3fe1ddced6c1db2e7ae57a477"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[argparse pyyaml ordereddict python-jenkins pbr six pip].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match(/Managed by Jenkins Job Builder/,
      pipe_output("#{bin}/jenkins-jobs test /dev/stdin",
                  "- job:\n    name: test-job\n\n", 0))
  end
end
