class AwsCloudsearch < Formula
  desc "Client for Amazon CloudSearch web service"
  homepage "https://aws.amazon.com/developertools/9054800585729911"
  url "https://s3.amazonaws.com/amazon-cloudsearch-data/cloud-search-tools-v2-2.0.1.0-2014.10.27.tar.gz"
  version "2.0.1.0-2014.10.27"
  sha256 "882a6442172957b27c0b3cd1f271531112092d4d227b528ce912b2e7ea886d51"
  revision 1

  depends_on :java => "1.7+"

  def install
    libexec.install %w[conf help third-party lib]
    bin.install Dir["bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.7+").merge(:CS_HOME => libexec))
  end

  test do
    system bin/"cs-configure-from-batches", "-h"
    system bin/"cs-import-documents", "-h"
  end
end
