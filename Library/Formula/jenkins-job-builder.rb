class JenkinsJobBuilder < Formula
  homepage "http://ci.openstack.org/jjb.html"
  url "https://pypi.python.org/packages/source/j/jenkins-job-builder/jenkins-job-builder-1.1.0.tar.gz"
  sha1 "e5d0665aaabefdd4b1bc24297bcedc8603c55853"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha1 "8a8d6c9624669055c2c4f70adcb129139dc50ee6"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha1 "ab90b67dceab55a11b609d253846fa486eb980c4"
  end

  resource "python-jenkins" do
    url "https://pypi.python.org/packages/source/p/python-jenkins/python-jenkins-0.4.5.tar.gz"
    sha1 "68a15cda9913e3df0305ad30ded18e1cb66c1a99"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-0.10.8.tar.gz"
    sha1 "8f90442f669e3a725d5682623aa94f9e38c4601d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-6.0.8.tar.gz"
    sha1 "bd59a468f21b3882a6c9d3e189d40c7ba1e1b9bd"
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
      assert_match /Managed by Jenkins Job Builder/,
          pipe_output("#{bin}/jenkins-jobs test /dev/stdin",
                      "- job:\n    name: test-job\n\n", 0)
  end
end
