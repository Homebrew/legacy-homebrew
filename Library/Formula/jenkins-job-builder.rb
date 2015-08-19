class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "http://ci.openstack.org/jjb.html"
  url "https://pypi.python.org/packages/source/j/jenkins-job-builder/jenkins-job-builder-1.2.0.tar.gz"
  sha256 "77ac34ff3679c4cd6e1b205955240a479a95e43433eef5caacb7d308166cdd26"

  bottle do
    cellar :any
    sha256 "30bee8cc99c0a246d403439c44e67ff1a223d1ac837163dcdc487b30e6429be5" => :yosemite
    sha256 "885374d41fb598a0388be54609542370a0bccd5229f2f4ed1eca35054ed6e716" => :mavericks
    sha256 "445d7a7267775eaa4ade261fc28eeef375c13025958d5a8b1fbeaff4974aa9ab" => :mountain_lion
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
    url "https://pypi.python.org/packages/source/p/python-jenkins/python-jenkins-0.4.5.tar.gz"
    sha256 "e69949ff81064b17bf9f82f89ce511b4c19a8ddd0a69c180494278905e86e85b"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-0.10.8.tar.gz"
    sha256 "a741650c697abe9dd3da00039a57a45a15a6eed017a16f6b7e4c0161fae2b4b2"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-6.0.8.tar.gz"
    sha256 "0d58487a1b7f5be2e5e965c11afbea1dc44ecec8069de03491a4d0d6c85f4551"
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
