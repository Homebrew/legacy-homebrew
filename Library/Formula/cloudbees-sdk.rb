require 'formula'

class CloudbeesSdk < Formula
  homepage 'http://wiki.cloudbees.com/bin/view/RUN/BeesSDK'
  url 'http://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-1.3.1-bin.zip'
  sha1 '4be79e78eae23a7894a305c20147fd48538bb6bd'

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
