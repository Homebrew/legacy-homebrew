class AwsElasticbeanstalk < Formula
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html"
  url "https://pypi.python.org/packages/source/a/awsebcli/awsebcli-3.1.2.tar.gz"
  sha1 "d64147b381574880b2f65e676b6e1b74a378d9cf"

  bottle do
    cellar :any
    sha1 "ed37af9d592efc5fd4b1922f106757d9a72b8915" => :yosemite
    sha1 "64c3503c04a9c0b0cce204175e44ebd691f3d485" => :mavericks
    sha1 "20eb4a35613dca9ef22b1a4caefde1690eeab483" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  resource "cement" do
    url "https://pypi.python.org/packages/source/c/cement/cement-2.4.0.tar.gz"
    sha1 "25e4fc1f85cc37fc6286bf0aa6cbf0ff23928044"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.0.tar.gz"
    sha1 "159081a4c5b3602ab440a7db305f987c00ee8c6d"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.6.1.tar.gz"
    sha1 "f3fc294e5225f2529968f58eb75c9da91fbeb9c1"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec) }
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bash_completion.install libexec/"bin/eb_completion.bash"
    bin.install Dir[libexec/"bin/{eb,jp}"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    system "#{bin}/eb", "--version"
  end
end
