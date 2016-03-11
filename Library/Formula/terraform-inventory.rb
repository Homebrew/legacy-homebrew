require "language/go"

class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.6.tar.gz"
  sha256 "af09a2606db728fd046e0ce5a6960386e5f766f8d187eea15220764fd669187e"
  head "https://github.com/adammck/terraform-inventory.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c2fb6c739555d94b6bf8518e166847dfaf12b826ac170b143bb37082f6035a0" => :el_capitan
    sha256 "279085b3061be61b2b35a49a609f4e88d46d90bab14718548851e40ebe8da7a0" => :yosemite
    sha256 "db95da0f598a7837337f137cae7284de1a9e8168105ebc93c1f66e74016a6b99" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "1f4a1643a57e798696635ea4c126e9127adb7d3c"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/adammck/"
    ln_sf buildpath, buildpath/"src/github.com/adammck/terraform-inventory"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"terraform-inventory", "-ldflags", "-X main.build_version='#{version}'"
  end

  test do
    example = <<-EOS.undent
        {
            "version": 1,
            "serial": 1,
            "modules": [
                {
                    "path": [
                        "root"
                    ],
                    "outputs": {},
                    "resources": {
                        "aws_instance.example_instance": {
                            "type": "aws_instance",
                            "primary": {
                                "id": "i-12345678",
                                "attributes": {
                                    "public_ip": "1.2.3.4"
                                },
                                "meta": {
                                    "schema_version": "1"
                                }
                            }
                        }
                    }
                }
            ]
        }
    EOS
    (testpath/"example.tfstate").write(example)
    assert_match(/example_instance/, shell_output("#{bin}/terraform-inventory --list example.tfstate"))
  end
end
