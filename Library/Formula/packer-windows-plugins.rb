require 'language/go'
require 'fileutils'
require 'pathname'

class PackerWindowsPlugins < Formula
  homepage "https://github.com/packer-community/packer-windows-plugins"
  url "https://github.com/packer-community/packer-windows-plugins/archive/v1.0.0.tar.gz"
  sha1 "b0577a2a4441fc1bad1c65fceca2b39f3963f6c9"

  depends_on "go" => :build

  go_resource "github.com/packer-community/packer-windows-plugins" do
    url "https://github.com/packer-community/packer-windows-plugins.git",
      :revision => "dd01a98a03273ab474957ebfe1b299814e8ca8af"
  end
  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "e8e6fd4fe12510cc46893dff18c5188a6a6dc549"
  end
  go_resource "github.com/mitchellh/multistep" do
    url "https://github.com/mitchellh/multistep.git",
      :revision => "162146fc57112954184d90266f4733e900ed05a5"
  end
  go_resource "github.com/packer-community/winrmcp" do
    url "https://github.com/packer-community/winrmcp.git",
      :revision => "650a91d1da6dc3fefa8f052289ffce648924a304"
  end
  go_resource "github.com/mitchellh/goamz" do
    url "https://github.com/mitchellh/goamz.git",
      :revision => "caaaea8b30ee15616494ee68abd5d8ebbbef05cf"
  end
  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
      :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end
  go_resource "github.com/mitchellh/packer" do
    url "https://github.com/mitchellh/packer.git",
      :revision => "c8b3dfff5fa8470f7d639c3e6b09f15ff09fa7c2"
  end
  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto",
      :revision => "69e2a90ed92d",
      :using => :hg
  end
  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git",
      :revision => "bb92dddfa9792e738a631f04ada52858a139bcf7"
  end
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
      :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end
  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "442e588f213303bec7936deba67901f8fc8f18b1"
  end
  go_resource "github.com/dylanmei/iso8601" do
    url "https://github.com/dylanmei/iso8601.git",
      :revision => "2075bf119b58e5576c6ed9f867b8f3d17f2e54d4"
  end
  go_resource "github.com/masterzen/winrm" do
    url "https://github.com/masterzen/winrm.git",
      :revision => "813d86ee814a2d07cb1153d0c1cb922f3f8239b7"
  end
  go_resource "github.com/masterzen/simplexml" do
    url "https://github.com/masterzen/simplexml.git",
      :revision => "95ba30457eb1121fa27753627c774c7cd4e90083"
  end
  go_resource "github.com/masterzen/xmlpath" do
    url "https://github.com/masterzen/xmlpath.git",
      :revision => "13f4951698adc0fa9c1dda3e275d489a24201161"
  end
  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
      :revision => "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end
  go_resource "github.com/mitchellh/go-fs" do
    url "https://github.com/mitchellh/go-fs.git",
      :revision => "faaa223588dd7005e49bf66fa2d19e35c8c4d761"
  end
  go_resource "github.com/going/toolkit" do
    url "https://github.com/going/toolkit.git",
      :revision => "6185c1893604d52d36a97dd6bb1247ace93a9b80"
  end
  go_resource "github.com/mitchellh/go-vnc" do
    url "https://github.com/mitchellh/go-vnc.git",
      :revision => "f54c4812027006edcb7fbbb78f5d013105fe2c53"
  end
  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "71c2886f5a673a35f909803f38ece5810165097b"
  end
  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "b2e55852ddaf823a85c67f798080eb7d08acd71d"
  end
  go_resource "github.com/rakyll/command" do
    url "https://github.com/rakyll/command.git",
      :revision => "0f2fed130caff9721655936b8a71d98b5252fc3a"
  end
  go_resource "github.com/racker/perigee" do
    url "https://github.com/racker/perigee.git",
      :revision => "44a7879d89b7040bcdb51164a83292ef5bf9deec"
  end
  go_resource "github.com/mitchellh/gophercloud-fork-40444fb" do
    url "https://github.com/mitchellh/gophercloud-fork-40444fb.git",
      :revision => "40444fbc2b10960682b34e6822eb9179216e1ae1"
  end


  def install
    pluginpath = Pathname.new("#{ENV['HOME']}/.packer.d/plugins")
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV.append_path "PATH", buildpath
    packerpath = buildpath/"src/github.com/packer-community/packer-windows-plugins"

    # Create Plugin Directory if not exist
    unless File.directory?(pluginpath)
      mkdir_p(pluginpath)
    end

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd packerpath do
      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-arch", arch,
        "-os", "darwin",
        "-output", "bin/packer-{{.Dir}}",
        "./..."
      cp_r Dir["bin/*"], pluginpath
      bin.install Dir["bin/*"]
    end
  end

  # This test should pass if Packer itself is not installed.
  test do
    require "open3"
    stdout, stderr, status = Open3.capture3("#{bin}/packer-provisioner-windows-shell")
    if stderr.include? "panic: Please do not execute plugins directly. Packer will execute these for you."
      return true
    end

    return false
  end
end
