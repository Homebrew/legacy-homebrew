require 'formula'

class DynamodbLocal < Formula
  homepage 'https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.html'
  url 'https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2013-09-12.tar.gz'
  version '2013-09-12'
  sha1 'b8e492b8908710c6ea8fb4b74624ecc7b168ea73'

  def data_path
    var/'data/dynamodb-local'
  end

  def log_path
    var/'log/dynamodb-local.log'
  end

  def bin_wrapper; <<-EOS.undent
    #!/bin/sh
    cd #{data_path} && java -Djava.library.path=#{libexec} -jar #{libexec}/DynamodbLocal.jar
    EOS
  end

  def install
    prefix.install %w[LICENSE.txt README.txt third_party_licenses]
    libexec.install %w[DynamodbLocal.jar libsqlite4java-osx.jnilib]
    (bin/'dynamodb-local').write(bin_wrapper)
  end

  def post_install
    data_path.mkpath
  end

  def caveats; <<-EOS.undent
    You must use version 7.x of the Java Runtime Engine (JRE).
    DynamoDB Local does not work on older Java versions.

    DynamoDB Local only supports V2 of the service API.

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
        <string>#{bin}/dynamodb-local</string>
      </array>
      <key>StandardErrorPath</key>
      <string>#{log_path}</string>
    </dict>
    </plist>
    EOS
  end
end
