class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "http://0install.net/"
  url "https://downloads.sf.net/project/zero-install/0install/2.8/0install-2.8.tar.bz2"
  sha256 "12de771be748bce9350c90bc4720029a566b078ceabd335af09386ac6a37df2b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f8fd9ea034aec0c405abc9504db4c06b4b870e62191964fef7fae3717c5a2255" => :el_capitan
    sha256 "636bfc8df15907e8c87728689b49ed551f814a3addd597e6e9d4cd7b819bc031" => :yosemite
    sha256 "6620f4b044215ae1ec0dcf374b1aba9d22f451a57b905b3b128c01e7df7d1042" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "gtk+" => :optional
  depends_on :gpg

  # 0install.2.8 resources from https://github.com/ocaml/opam-repository.git

  resource "easy-format" do # [required by yojson]
    url "https://opam.ocaml.org/archives/easy-format.1.0.2+opam.tar.gz"
    sha256 "c2a04ab1084bc5ce1ec52a3aa320c825c22f8be527fb5f82d920a9d92a673cd3"
  end

  resource "biniou" do # [required by yojson]
    url "https://opam.ocaml.org/archives/biniou.1.0.9+opam.tar.gz"
    sha256 "08e6a17a19fbe5e9da4c77d1e8c1bb05333f84ec8a634721a39c6c505ce51e0d"
  end

  resource "cppo" do # [required by yojson]
    url "https://opam.ocaml.org/archives/cppo.1.1.2+opam.tar.gz"
    sha256 "8341d5a37d9e9351c1a46bf4d0843bff4fe1690b6329c28f8f41ca3dd189252a"
  end

  resource "yojson" do
    url "https://opam.ocaml.org/archives/yojson.1.1.8+opam.tar.gz"
    sha256 "20ce2c2f752b49695468b0bf66f17cf20219d7bca5a0b71a3fb89af500fb52f1"
  end

  resource "xmlm" do
    url "https://opam.ocaml.org/archives/xmlm.1.2.0+opam.tar.gz"
    sha256 "a73af14cb2771247311e9130cbf7d10d66970f4725359db0923c92106ba94457"
  end

  resource "ounit" do
    url "https://opam.ocaml.org/archives/ounit.2.0.0+opam.tar.gz"
    sha256 "5a26c6404d9c8701f5a7510a985963f4eae003d58ae5fc3d9b7f1a862e91de71"
  end

  resource "react" do
    url "https://opam.ocaml.org/archives/react.1.2.0+opam.tar.gz"
    sha256 "51cab5941511220cd3f51b04cbab58ed34409bf9ec78dfed7611ab169f294499"
  end

  resource "ppx_tools" do # [required by lwt]
    url "https://opam.ocaml.org/archives/ppx_tools.0.99.2+opam.tar.gz"
    sha256 "0c5b9802de2005b55717ac78bffcead1ee11dd28f91fb32f7e3518a7d7d8c48a"
  end

  resource "lwt" do
    url "https://opam.ocaml.org/archives/lwt.2.4.6+opam.tar.gz"
    sha256 "f0d814e04e4447322b592ee38b2bb634287bc6142c195381da39e28d4a0e9071"
  end

  resource "extlib" do
    url "https://opam.ocaml.org/archives/extlib.1.6.1+opam.tar.gz"
    sha256 "c76176916c39d4ccae82a34c33e694652c0c55d79eec8830dfddadb580b53773"
  end

  resource "ocurl" do
    url "https://opam.ocaml.org/archives/ocurl.0.7.2+opam.tar.gz"
    sha256 "669c5142b7f4002521468b75ee254b269f0094c9a22d3381e94a440a6aa2d400"
  end

  if build.with? "gtk+"
    resource "lablgtk" do
      url "https://opam.ocaml.org/archives/lablgtk.2.18.3+opam.tar.gz"
      sha256 "f0b7ed0bd85f6cf4b4c5f81966f03763e76bb9f866f5172511ce48cf31fd433c"
    end
  end

  resource "sha" do
    url "https://opam.ocaml.org/archives/sha.1.9+opam.tar.gz"
    sha256 "d3cfda4cd6f79b01c6613219baa3e8548365c309952168b3539e0edce9370b40"
  end

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    archives = opamroot/"repo/default/archives"
    modules = []
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      original_name = File.basename(r.url)
      cp r.cached_download, archives/original_name
      modules << "#{r.name}=#{r.version}"
    end
    system "opam", "install", *modules

    system "opam", "config", "exec", "make"
    inreplace "dist/install.sh", '"/usr/local"', prefix
    inreplace "dist/install.sh", '"${PREFIX}/man"', man
    system "make", "install"
  end

  test do
    (testpath/"hello.py").write <<-EOS.undent
      print("hello world")
    EOS
    (testpath/"hello.xml").write <<-EOS.undent
      <?xml version="1.0" ?>
      <interface xmlns="http://zero-install.sourceforge.net/2004/injector/interface">
        <name>Hello</name>
        <summary>minimal demonstration program</summary>

        <implementation id="." version="0.1-pre">
          <command name='run' path='hello.py'>
            <runner interface='http://repo.roscidus.com/python/python'></runner>
          </command>
        </implementation>
      </interface>
    EOS
    assert_equal "hello world\n", shell_output("#{bin}/0launch --console hello.xml")
  end
end
