require "language/go"

class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v0.9.5.tar.gz"
  sha256 "43de181dd8770e5c0ffeb4de9f862c22c59381df5d9220a54c680bd2468ff831"

  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "50233a52a6021e47b50a0280263984fda75bfe8811a384f31fc1975e579646a1" => :yosemite
    sha256 "c12651d38a4145136c2d8441c0a1a77e4f4da14697ff9983482b4ce95a728683" => :mavericks
    sha256 "9d3780503b8d9416435f4e8bfd85673e9caf4745657bfaba889ba7000c7e1bb0" => :mountain_lion
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "github.com/mattn/gom" do
    url "https://github.com/mattn/gom.git", :revision => "2ed6c170e43a3fea036789a1e60a25c0a3bde149"
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid/", :revision => "5fac954758f5", :using => :hg
  end

  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto/", :revision => "7aa593ce8cea", :using => :hg
  end

  go_resource "code.google.com/p/gographviz" do
    url "https://code.google.com/p/gographviz/", :revision => "454bc64fdfa2", :using => :git
  end

  go_resource "code.google.com/p/mxk" do
    url "https://code.google.com/p/mxk/", :revision => "5ff2502e2556", :using => :hg
  end

  go_resource "code.google.com/p/snappy-go" do
    url "https://code.google.com/p/snappy-go/", :revision => "12e4b4183793", :using => :hg
  end

  go_resource "github.com/AlekSi/pointer" do
    url "https://github.com/AlekSi/pointer.git", :revision => "5f6d527dae3d678b46fbb20331ddf44e2b841943"
  end

  go_resource "github.com/cheggaaa/pb" do
    url "https://github.com/cheggaaa/pb.git", :revision => "2c1b74620cc58a81ac152ee2d322e28c806d81ed"
  end

  go_resource "github.com/gin-gonic/gin" do
    url "https://github.com/gin-gonic/gin.git", :revision => "b1758d3bfa09e61ddbc1c9a627e936eec6a170de"
  end

  go_resource "github.com/jlaffaye/ftp" do
    url "https://github.com/jlaffaye/ftp.git", :revision => "fec71e62e457557fbe85cefc847a048d57815d76"
  end

  go_resource "github.com/julienschmidt/httprouter" do
    url "https://github.com/julienschmidt/httprouter.git", :revision => "46807412fe50aaceb73bb57061c2230fd26a1640"
  end

  go_resource "github.com/mattn/go-shellwords" do
    url "https://github.com/mattn/go-shellwords.git", :revision => "c7ca6f94add751566a61cf2199e1de78d4c3eee4"
  end

  go_resource "github.com/mitchellh/goamz" do
    url "https://github.com/mitchellh/goamz.git", :revision => "e7664b32019f31fd1bdf33f9e85f28722f700405"
  end

  go_resource "github.com/mkrautz/goar" do
    url "https://github.com/mkrautz/goar.git", :revision => "36eb5f3452b1283a211fa35bc00c646fd0db5c4b"
  end

  go_resource "github.com/ncw/swift" do
    url "https://github.com/ncw/swift.git", :revision => "384ef27c70645e285f8bb9d02276bf654d06027e"
  end

  go_resource "github.com/smira/commander" do
    url "https://github.com/smira/commander.git", :revision => "f408b00e68d5d6e21b9f18bd310978dafc604e47"
  end

  go_resource "github.com/smira/flag" do
    url "https://github.com/smira/flag.git", :revision => "357ed3e599ffcbd4aeaa828e1d10da2df3ea5107"
  end

  go_resource "github.com/smira/go-ftp-protocol" do
    url "https://github.com/smira/go-ftp-protocol.git", :revision => "066b75c2b70dca7ae10b1b88b47534a3c31ccfaa"
  end

  go_resource "github.com/syndtr/goleveldb" do
    url "https://github.com/syndtr/goleveldb.git", :revision => "97e257099d2ab9578151ba85e2641e2cd14d3ca8"
  end

  go_resource "github.com/syndtr/gosnappy" do
    url "https://github.com/syndtr/gosnappy.git", :revision => "ce8acff4829e0c2458a67ead32390ac0a381c862"
  end

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git", :revision => "71c2886f5a673a35f909803f38ece5810165097b"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git", :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/wsxiaoys/terminal" do
    url "https://github.com/wsxiaoys/terminal.git", :revision => "5668e431776a7957528361f90ce828266c69ed08"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git", :revision => "b5c0891944c2f150ccc9d02aecf51b76c14c2948"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "a7ead6ddf06233883deca151dffaef2effbf498f"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git", :revision => "723cc1e459b8eea2dea4583200fd60757d40097a"
  end

  go_resource "github.com/manucorporat/sse" do
    url "https://github.com/manucorporat/sse.git", :revision => "fe6ea2c8e398672518ef204bf0fbd9af858d0e15"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git", :revision => "40e4aedc8fabf8c23e040057540867186712faa5"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git", :revision => "db8e4de5b2d6653f66aea53094624468caad15d2"
  end

  go_resource "gopkg.in/bluesuncorp/validator.v5" do
    url "https://github.com/bluesuncorp/validator.git", :revision => "8324129b028239a2d26c4221165e7d4d512ea697"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/smira/"
    ln_s buildpath, "#{buildpath}/src/github.com/smira/aptly"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    cd "#{buildpath}/src/github.com/mattn/gom" do
      system "go", "install"
    end

    system "./bin/gom", "build", "-o", "bin/aptly"
    bin.install "bin/aptly"
  end

  test do
    assert_match "aptly version:", shell_output("aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
