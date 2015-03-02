class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage "http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html"
  url "https://pypi.python.org/packages/source/a/awsebcli/awsebcli-3.0.10.tar.gz"
  sha1 "60cb08e1946c6fa141c4708c2ea2020e2c03f0fc"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :java

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
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

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-12.3.tar.gz"
    sha1 "1c43b290e8de50e4f1e1074e179289dc9cddfbf2"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec) }
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bash_completion.install libexec/"bin/eb_completion.bash"
    bin.install Dir[libexec/"bin/{eb,jp}"]
    bin.env_script_all_files(libexec+"bin", Language::Java.java_home_env.merge(:PYTHONPATH => ENV["PYTHONPATH"]))
  end

  test do
    system "#{bin}/eb", "--version"
  end
end
