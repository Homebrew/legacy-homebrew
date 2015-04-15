class AwsCloudsearch < Formula
  homepage "https://aws.amazon.com/developertools/9054800585729911"
  url "https://s3.amazonaws.com/amazon-cloudsearch-data/cloud-search-tools-v2-2.0.1.0-2014.10.27.tar.gz"
  version "2.0.1.0-2014.10.27"
  sha256 "882a6442172957b27c0b3cd1f271531112092d4d227b528ce912b2e7ea886d51"

  depends_on :java => "1.7+"

  def install
    inreplace "bin/cs-cmd", 'LIBDIR="${CS_HOME}/lib"', 'LIBDIR="${CS_HOME}/jars/lib"'
    (prefix/"jars").install "lib"
    prefix.install %w[bin conf help third-party]
  end

  def caveats; <<-EOS.undent
    Add these to your shell profile:
      export JAVA_HOME="$(/usr/libexec/java_home)"
      export CS_HOME="#{prefix}"
    EOS
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["CS_HOME"] = prefix
    system "#{bin}/cs-configure-from-batches", "-h"
  end
end
