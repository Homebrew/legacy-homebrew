class Sslyze < Formula
  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  url "https://github.com/nabla-c0d3/sslyze/archive/release-0.11.tar.gz"
  sha256 "d0adf9be09d5b27803a923dfabd459c84a2eddb457dac2418f1bf074153f8f93"
  version "0.11.0"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "473288500a16b32e0c5031fcec056c817da68a45cf8821b7ca04fb58ff87c1bc" => :el_capitan
    sha256 "762c505503cc5582777d342786a2be10dd020b90de08a4e98cbe0625b74f5d09" => :yosemite
    sha256 "0c2e3a2e463652fd2290e00434c4900ca10b5083aefecd2d489e3ccfceb8ac5f" => :mavericks
  end

  depends_on :arch => :x86_64
  depends_on :python if MacOS.version <= :snow_leopard

  resource "nassl" do
    url "https://github.com/nabla-c0d3/nassl/archive/v0.11.tar.gz"
    sha256 "83fe1623ad3e67ba01a3e692211e9fde15c6388f5f3d92bd5c0423d4e9e79391"
  end

  resource "openssl" do
    url "https://www.openssl.org/source/old/1.0.2/openssl-1.0.2a.tar.gz"
    sha256 "15b6393c20030aab02c8e2fe0243cb1d1d18062f6c095d67bca91871dc7f324a"
  end

  resource "zlib" do
    url "http://zlib.net/zlib-1.2.8.tar.gz"
    sha256 "36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d"
  end

  def install
    # openssl fails on parallel build. Related issues:
    # - http://rt.openssl.org/Ticket/Display.html?id=3736
    # - http://rt.openssl.org/Ticket/Display.html?id=3737
    ENV.deparallelize

    resource("openssl").stage do
      (buildpath/"nassl/openssl-1.0.2a").install Dir["*"]
    end

    resource("zlib").stage do
      (buildpath/"nassl/zlib-1.2.8").install Dir["*"]
    end

    resource("nassl").stage do
      (buildpath/"nassl").install Dir["*"]
    end

    cd "nassl" do
      system "python", "buildAll_unix.py"
      libexec.install "test/nassl"
    end

    libexec.install %w[plugins utils sslyze.py xml_out.xsd]
    bin.install_symlink libexec/"sslyze.py" => "sslyze"
  end

  test do
    assert_equal "0.11.0", shell_output("#{bin}/sslyze --version").strip
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
