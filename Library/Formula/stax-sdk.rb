require 'formula'

class StaxSdk <Formula
  url 'http://stax-downloads.s3.amazonaws.com/sdk/stax-sdk-0.3.8-dist.zip'
  version '0.3.8'
  homepage 'http://wiki.stax.net/w/index.php/SDK'
  md5 'db14071f8c1628ed23bb66369fcca8bf'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      export STAX_HOME=#{libexec}
      #{libexec}/#{target} $*
    EOS
  end

  def install
    rm Dir['*.bat', '*.lnk']
    libexec.install Dir['*']

    (bin+'stax').write shim_script('stax')
    (bin+'staxd').write shim_script('staxd')
  end
end
