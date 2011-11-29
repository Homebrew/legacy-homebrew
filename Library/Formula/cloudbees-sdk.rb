require 'formula'

class CloudbeesSdk < Formula
  url 'http://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-0.7.3-dist.zip'
  version '0.7.3'
  homepage 'https://cloudbees.zendesk.com/entries/414109-cloudbees-sdk'
  md5 '97354d0bec3d99aa3833b7a320d5f256'

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
