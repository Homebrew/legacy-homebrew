require 'formula'

class CloudbeesSdk < Formula
  homepage 'http://wiki.cloudbees.com/bin/view/RUN/BeesSDK'
  url 'http://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-1.2.2-bin.zip'
  sha1 '7f0a6f2437f1130082e815d0da7e8a5577bf9cbd'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      export BEES_HOME=#{libexec}
      "#{libexec}/#{target}" "$@"
    EOS
  end

  def install
    rm Dir['*.bat', '*.lnk']
    libexec.install Dir['*']

    (bin+'bees').write shim_script('bees')
    (bin+'beesd').write shim_script('beesd')
    (bin+'stax').write shim_script('stax')
    (bin+'staxd').write shim_script('staxd')
  end
end
