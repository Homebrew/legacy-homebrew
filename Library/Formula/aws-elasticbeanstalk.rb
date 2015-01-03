class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage "http://aws.amazon.com/code/6752709412171743"
  url "https://pypi.python.org/packages/source/a/awsebcli/awsebcli-3.0.10.tar.gz"
  sha1 "60cb08e1946c6fa141c4708c2ea2020e2c03f0fc"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bash_completion.install libexec/"bin/eb_completion.bash"
    bin.install Dir[libexec/"bin/{eb,jp}"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/eb", "--version"
  end
end
