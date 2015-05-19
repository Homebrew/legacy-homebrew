class Sslyze < Formula
  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  url "https://github.com/nabla-c0d3/sslyze/archive/release-0.11.tar.gz"
  sha256 "d0adf9be09d5b27803a923dfabd459c84a2eddb457dac2418f1bf074153f8f93"
  version "0.11.0"

  bottle do
    cellar :any
    sha256 "af01a93c9a4b8d8e38c4b03255fd522234fdb24165cdde6b5a910187fa9fa16b" => :yosemite
    sha256 "63f3129057130bc335464e64ac4a408947c39f58d04b051a55360644b05bc803" => :mavericks
    sha256 "6ef8e398d5ecd7b71e80d8fe113c23acd5be75055bf8253dbb42e2e4a0e825d8" => :mountain_lion
  end

  depends_on :arch => :x86_64
  depends_on :python if MacOS.version <= :snow_leopard

  resource "nassl" do
    url "https://github.com/nabla-c0d3/nassl/archive/v0.11.tar.gz"
    sha256 "83fe1623ad3e67ba01a3e692211e9fde15c6388f5f3d92bd5c0423d4e9e79391"
  end

  resource "openssl" do
    url "https://www.openssl.org/source/openssl-1.0.2a.tar.gz"
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
