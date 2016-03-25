class DynamodbLocal < Formula
  desc "Client-side database and server imitating DynamoDB"
  homepage "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html"
  url "https://dynamodb-local.s3.amazonaws.com/dynamodb_local_2016-03-01.tar.gz"
  version "2016-03-01"
  sha256 "c102d30a2f3d420fc9a4784fd7544bccdf3bc8782203ef63e3f92942c4493c93"

  bottle :unneeded

  def data_path
    var/"data/dynamodb-local"
  end

  def log_path
    var/"log/dynamodb-local.log"
  end

  def bin_wrapper; <<-EOS.undent
    #!/bin/sh
    cd #{data_path} && java -Djava.library.path=#{libexec}/DynamodbLocal_lib -jar #{libexec}/DynamoDBLocal.jar "$@"
    EOS
  end

  def install
    prefix.install %w[LICENSE.txt README.txt third_party_licenses]
    libexec.install %w[DynamoDBLocal_lib DynamoDBLocal.jar]
    (bin/"dynamodb-local").write(bin_wrapper)
  end

  def post_install
    data_path.mkpath
  end

  def caveats; <<-EOS.undent
    DynamoDB Local supports the Java Runtime Engine (JRE) version 6.x or
    newer; it will not run on older JRE versions.

    In this release, the local database file format has changed;
    therefore, DynamoDB Local will not be able to read data files
    created by older releases.

    Data: #{data_path}
    Logs: #{log_path}
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/bin/dynamodb-local"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/dynamodb-local</string>
      </array>
      <key>StandardErrorPath</key>
      <string>#{log_path}</string>
    </dict>
    </plist>
    EOS
  end
end
