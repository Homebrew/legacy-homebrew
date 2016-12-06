require 'formula'

class WhiskCli < Formula
  homepage 'https://github.com/vlmiroshnikov/whisk-api-client'
  url 'https://github.com/downloads/vlmiroshnikov/whisk-api-client/whisk-cli-0.1.jar'
  sha1 'en0ad1a9ef67623b3dde9ef310cec02db350bdc7fbd'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/whisk-cli-#{version}.jar" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']
    (bin/'whisk-cli').write startup_script('whisk-cli')
  end
end