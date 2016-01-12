class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "http://ci.openstack.org/jjb.html"
  url "https://pypi.python.org/packages/source/j/jenkins-job-builder/jenkins-job-builder-1.4.0.tar.gz"
  sha256 "0b3bfdb53a2771d510142f72a8a2d60eac03fcfce04ccff2e6d079df06bef183"

  bottle do
    cellar :any
    sha256 "9e9619dbd6123e278cb939649ec874b7b6784c6c2a6e921367e2bb0d140c24cb" => :yosemite
    sha256 "0ebaeea8fe2d464b9f26fe7b6064e62a2d5e81d39e22a1090c4a317ff6fb5477" => :mavericks
    sha256 "e6a4404578fb17990d288758013e50e64e31306c74091eb7f79a3d1a4cd2b893" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "python-jenkins" do
    url "https://pypi.python.org/packages/source/p/python-jenkins/python-jenkins-0.4.12.tar.gz"
    sha256 "673868980f4b2312447843a86b61e18777a16a1adf5eb9cdfd56cbbfa3e50ee4"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-0.11.1.tar.gz"
     sha256 "701ab2922c29ca6004e3a4aab968728f33224968de9b51e432be2ee3340c2309"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
    sha256 "ca047986f0528cfa975a14fb9f7f106271d4e0c3fe1ddced6c1db2e7ae57a477"
  end

  resource "multi_key_dict" do
    url "https://pypi.python.org/packages/source/m/multi_key_dict/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pyyaml ordereddict python-jenkins pbr six pip multi_key_dict].each do |r|
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
