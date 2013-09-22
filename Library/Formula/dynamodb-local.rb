require 'formula'

class DynamodbLocal < Formula
  homepage 'https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.html'
  url 'https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2013-09-12.tar.gz'
  sha1 'b8e492b8908710c6ea8fb4b74624ecc7b168ea73'

  version '2013-09-12'

  def install
    prefix.install Dir['*']
  end

  def post_install
    (var/'data/dynamodb-local').mkpath
    (var/'log/dynamodb-local').mkpath
  end

  def caveats; <<-EOS.undent
    You must use version 7.x of the Java Runtime Engine (JRE); DynamoDB Local does not work on older Java versions.

    DynamoDB Local only supports V2 of the service API.

    Data:    #{var}/data/dynamodb-local
    Logs:    #{var}/log/dynamodb-local
    EOS
  end

  plist_options :manual => "java -Djava.library.path=#{HOMEBREW_PREFIX}/opt/dynamodb-local -jar #{HOMEBREW_PREFIX}/opt/dynamodb-local/DynamoDBLocal.jar"

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
        <string>-Djava.library.path=#{prefix}/</string>
        <string>-jar</string>
        <string>#{prefix}/DynamoDBLocal.jar</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{var}/data/dynamodb-local</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/dynamodb-local/stdout.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/dynamodb-local/stderr.log</string>
    </dict>
    </plist>
    EOS
  end
end
