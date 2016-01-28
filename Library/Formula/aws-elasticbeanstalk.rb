class AwsElasticbeanstalk < Formula
  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html"
  url "https://pypi.python.org/packages/source/a/awsebcli/awsebcli-3.7.2.tar.gz"
  sha256 "22e7b4ce7b85d5a2deef86903f0bf7763121b27f55cbcda1d79c752007ffe36c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8edc515bf4914d58a5a24cb3fb8fed36ddf779dfa54ea889087cf634318b2231" => :el_capitan
    sha256 "34018a2899f84c3f9d78b2e3dbd8982ebab1349cb2553356464e01622863ec0c" => :yosemite
    sha256 "c8f4ed19adc36574c0ec234ce9fd0137227ca5ac9f226bef66ba4125cc43f409" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "cement" do
    url "https://pypi.python.org/packages/source/c/cement/cement-2.4.0.tar.gz"
    sha256 "81c46cd056cbc7e48ae2342b3a65afbae4732b09af5d1d3e2e079678d2ccd5bb"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "pathspec" do
    url "https://pypi.python.org/packages/source/p/pathspec/pathspec-0.3.3.tar.gz"
    sha256 "38d0613ee2ce75adbbad61a33895c3b88122c768a732fb14800e6f660cc1380b"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.2.tar.gz"
    sha256 "0577249d4b6c4b11fd97c28037e98664bfaa0559022fee7bcef6b752a106e505"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.4.tar.gz"
    sha256 "8587b61cb6c6022d0eb79e56e59825df4353f0f33099b4ae3bcfe8d41bd1702e"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket_client-0.34.0.tar.gz"
    sha256 "682a6241ca953499f06ca506f69aa3ea26f0ed2a41fe7982732cb8449ae92ddf"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.1.0.tar.gz"
    sha256 "6a07eb56b234719e89d3038c24f9c870b6f1ee0b58080120e865e2752673cd94"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.3.4.tar.gz"
    sha256 "a51044cc49089a2408fdf6769a63eebe0b16d91f34716ecee681984446ce467d"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "blessed" do
    url "https://pypi.python.org/packages/source/b/blessed/blessed-1.9.5.tar.gz"
    sha256 "b93b5c7600814638c0913c8325608327a24e3731977d9a4f003ecf37b08ca6e5"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.3.1.tar.gz"
    sha256 "23591dc68edfae2f55efab89a6eb250ea1d49d25f16adbf9934b8a2cbc520928"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.5.tar.gz"
    sha256 "66c7ce3199c87833aaaa1fe1241b63261ce53c1062597c189a16a54713e0919d"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
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

  test do
    system "#{bin}/eb", "--version"
  end
end
