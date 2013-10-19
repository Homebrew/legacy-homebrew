require 'formula'

class CloudbeesSdk < Formula
  homepage 'http://wiki.cloudbees.com/bin/view/RUN/BeesSDK'
  url 'http://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-1.5.2-bin.zip'
  sha1 '8c0d0e6ef3c412d07b5a939afd70dcdc0b4b913b'

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
