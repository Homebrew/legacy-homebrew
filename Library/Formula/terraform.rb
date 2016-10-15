require "formula"

class Terraform < Formula
  homepage "http://www.terraform.io"
  url "https://dl.bintray.com/mitchellh/terraform/0.1.0_darwin_amd64.zip"
  version '0.1.0'
  sha256 "309aed0ed61586e2682f58b77781f8e9805745a5edd1aebcddf883c9f624a0b9"

  def install
    bin.install %w[terraform terraform-provider-aws terraform-provider-consul
                  terraform-provider-digitalocean terraform-provider-dnsimple
                  terraform-provider-heroku terraform-provisioner-file
                  terraform-provisioner-local-exec
                  terraform-provisioner-remote-exec]
  end

  test do
    system "#{bin}/terraform", "version"
  end
end
