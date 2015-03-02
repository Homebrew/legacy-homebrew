class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage "http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html"
  url "https://pypi.python.org/packages/source/a/awsebcli/awsebcli-3.1.2.tar.gz"
  sha1 "d64147b381574880b2f65e676b6e1b74a378d9cf"

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
