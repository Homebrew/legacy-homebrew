class CloudbeesSdk < Formula
  desc "Command-line tools to make use of the CloudBees Platform"
  homepage "https://wiki.cloudbees.com/bin/view/RUN/BeesSDK"
  url "https://cloudbees-downloads.s3.amazonaws.com/sdk/cloudbees-sdk-1.5.2-bin.zip"
  sha256 "48deb95a01e314c24ffa84b7ac99f98bfa24d9eea8e5883a18c7bd09a240ea8b"

  bottle :unneeded

  def shim_script(target)
    <<-EOS.undent
      #!/bin/bash
      export BEES_HOME=#{libexec}
      "#{libexec}/#{target}" "$@"
    EOS
  end

  def install
    rm Dir["*.bat", "*.lnk"]
    libexec.install Dir["*"]

    (bin+"bees").write shim_script("bees")
    (bin+"beesd").write shim_script("beesd")
    (bin+"stax").write shim_script("stax")
    (bin+"staxd").write shim_script("staxd")
  end
end
