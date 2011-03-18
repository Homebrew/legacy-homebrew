require 'formula'

class CloudbeesSdk < Formula
  url 'http://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-0.5.0-dist.zip'
  version '0.5.0'
  homepage 'https://cloudbees.zendesk.com/entries/414109-cloudbees-sdk'
  md5 'e3e2f68b687df9db3a7ceb46df49e000'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      export BEES_HOME=#{libexec}
      #{libexec}/#{target} $*
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
