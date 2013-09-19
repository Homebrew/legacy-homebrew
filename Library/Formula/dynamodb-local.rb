require 'formula'

class DynamodbLocal < Formula
  homepage 'https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.html'
  url 'https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2013-09-12.tar.gz'
  sha1 'b8e492b8908710c6ea8fb4b74624ecc7b168ea73'

  version '2013-09-12'

  def install
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    You must use version 7.x of the Java Runtime Engine (JRE); DynamoDB Local does not work on older Java versions.
    EOS
  end

  plist_options :manual => "java -jar #{HOMEBREW_PREFIX}/opt/dynamodb-local/DynamoDBLocal.jar"

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
        <string>/usr/bin/java</string>
        <string>-jar</string>
        <string>#{prefix}/DynamoDBLocal.jar</string>
      </array>
      <key>StandardErrorPath</key>
      <string>/var/log/dynamodb/error.log</string>
      <key>StandardOutPath</key>
      <string>/var/log/dynamodb/dynamodb.log</string>
    </dict>
    </plist>
    EOS
  end
end
