require "language/go"

class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.6.1.tar.gz"
  sha256 "9cdcbc5ce4247b72bb72923d01246f51252a88908d760d766daeac51dd8feed9"
  head "https://github.com/adammck/terraform-inventory.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d876b7acee1bfaaeaaf284bfd8518195b10005f7de504c8aaf39be3164b93dac" => :el_capitan
    sha256 "77b4cfd96088f6019ad5bd0f0faf6757d1fb8c34ea3b327490ff33fde03538c1" => :yosemite
    sha256 "19fed440ba3c95ef85fcd529f151131136fa684c9a091d17177ac8f74426e7d5" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "f390dcf405f7b83c997eac1b06768bb9f44dec18"
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
