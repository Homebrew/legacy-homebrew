require 'formula'

class CloudbeesSdk < Formula
  url 'http://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-0.6.0-dist.zip'
  version '0.6.0'
  homepage 'https://cloudbees.zendesk.com/entries/414109-cloudbees-sdk'
  md5 '2e109218d5a4537548e41a0a0e7ed5c7'

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
