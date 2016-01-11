class AwsApigatewayImporter < Formula
  desc "AWS API Gateway Importer"
  homepage "https://github.com/awslabs/aws-apigateway-importer"
  url "https://github.com/awslabs/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "1aecfd348135c2e364ce5e105d91d5750472ac4cb8848679d774a2ac00024d26"

  bottle do
    cellar :any_skip_relocation
    sha256 "9502ccfebbcbc7171e910fb5dc5bdc10b5295856a643d486d69ca91b8222e0da" => :el_capitan
    sha256 "7eebf5e4c557846a8b6eaea7ccee169bd5fc0cce2b4f37308f948e17c69691eb" => :yosemite
    sha256 "edb2aa2cfa42baeda657d4b02ff7dc76e9f1386fe992da1d80d5b626427f152d" => :mavericks
  end

  depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "assembly:assembly"
    libexec.install "target/aws-apigateway-importer-1.0.1-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"aws-apigateway-importer-1.0.1-jar-with-dependencies.jar", "aws-api-import"
  end

  test do
    assert_match(/^Usage:\s+aws-api-import/, shell_output("#{bin}/aws-api-import --help"))
  end
end
