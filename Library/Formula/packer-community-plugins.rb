class PackerCommunityPlugins < Formula
  homepage "https://github.com/packer-community/packer-windows-plugins"
  version "0.0.1"

  if Hardware.is_64_bit?
    url "https://github.com/packer-community/packer-windows-plugins/releases/download/pre-release/darwin_amd64.zip"
    sha1 "fce06cc7882a4e38c81db1af62c8ee5675c2efd4"
  else
    url "https://github.com/packer-community/packer-windows-plugins/releases/download/pre-release/darwin_386.zip"
    sha1 'abb4a47e880de0d6c405cc8b72747122657a2129'
  end

  depends_on :arch => :intel
  depends_on "packer" => :recommended

  def install
    bin.install Dir['*']
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
    {
    "builders": [
      {
        "type": "amazon-windows-ebs",
        "region": "ap-southeast-1",
        "source_ami": "ami-e01f3db2",
        "instance_type": "t2.medium",
        "ami_name": "packer-community-nossh-{{timestamp}}",
        "associate_public_ip_address":true,
        "winrm_username": "vagrant",
        "winrm_password": "vagrant",
        "winrm_wait_timeout": "5m",
        "winrm_port":5985,
        "vpc_id": "vpc-e141b084",
        "subnet_id":"subnet-c774bfa2",
        "security_group_id":"sg-a74d86c2"
      }
    ]
    }
    EOS
    system "packer", "validate", minimal
  end
end
