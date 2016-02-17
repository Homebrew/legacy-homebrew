require "language/go"

class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/1.1.0.tar.gz"
  sha256 "589222d922aa4ebae2039a54c46b9a7c2df4c95d78026ab35768a6cf62836ca9"
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any
    sha256 "1c28f3caabe350a72649f2cb4ebefe53cd28888ea3385a44253ed44e0165a03d" => :el_capitan
    sha256 "a3ad35a05b855341a92ff410d63cfd1dc275f613ad31243d4062f0d3365e11c3" => :yosemite
    sha256 "a5f1d86658b3c0927bbecd0c4aed184f0285c1a638762113aa70f4a2053c163e" => :mavericks
  end

  depends_on "go" => :build
  depends_on "libtool" => :run

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "3760e016850398b85094c4c99e955b8c3dea5711"
  end

  go_resource "github.com/GeertJohan/go.rice" do
    url "https://github.com/GeertJohan/go.rice.git",
      :revision => "ada95a01c963696fb73320ee662195af68be81ae"
  end

  go_resource "github.com/cloudflare/cf-tls" do
    url "https://github.com/cloudflare/cf-tls.git",
      :revision => "28cbf4e4c1f859789a26b308eb8b684f34f38312"
  end

  go_resource "github.com/daaku/go.zipexe" do
    url "https://github.com/daaku/go.zipexe.git",
      :revision => "a5fe2436ffcb3236e175e5149162b41cd28bd27d"
  end

  go_resource "github.com/miekg/pkcs11" do
    url "https://github.com/miekg/pkcs11.git",
      :revision => "80f102b5cac759de406949c47f0928b99bd64cdf"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
      :revision => "6e7f843663477789fac7c02def0d0909e969b4e5"
  end

  # These two aren't needed anymore after the vendored Godeps were added.
  # Can't hurt to have them anyway, though.
  go_resource "github.com/coreos/go-systemd" do
    url "github.com/coreos/go-systemd.git",
    :revision => "2ed5b5012ccde5f057c197890a2c801295941149"
  end

  go_resource "github.com/dgryski/go-rc2" do
    url "https://github.com/dgryski/go-rc2.git",
      :revision => "8a9021637152186df738b1ec376caf2100fef194"
  end

  head do
    go_resource "github.com/cloudflare/go-metrics" do
      url "https://github.com/cloudflare/go-metrics.git",
        :revision => "f009caf6e47cccc4641d4252277f4af0196d89c4"
    end

    go_resource "github.com/cloudflare/redoctober" do
      url "https://github.com/cloudflare/redoctober.git",
        :revision => "1bfa291c370c137cee14ddee7029554ae0d4fc88"
    end

    go_resource "github.com/google/certificate-transparency" do
      url "https://github.com/google/certificate-transparency.git",
        :revision => "3f987269ebe76f2bf3bbf88e10d21a45f4bffb04"
    end

    go_resource "github.com/jmhodges/clock" do
      url "https://github.com/jmhodges/clock.git",
        :revision => "3c4ebd218625c9364c33db6d39c276d80c3090c6"
    end

    go_resource "github.com/kisielk/sqlstruct" do
      url "https://github.com/kisielk/sqlstruct.git",
        :revision => "648daed35d49dac24a4bff253b190a80da3ab6a5"
    end

    go_resource "github.com/lib/pq" do
      url "https://github.com/lib/pq.git",
        :revision => "83c4f410d0aed80a0f44bac6a576a7f2435791f3"
    end

    go_resource "github.com/mattn/go-sqlite3" do
      url "https://github.com/mattn/go-sqlite3.git",
        :revision => "2513631704612107a1c8b1803fb8e6b3dda2230e"
    end

    go_resource "github.com/mreiferson/go-httpclient" do
      url "https://github.com/mreiferson/go-httpclient.git",
        :revision => "63fe23f7434723dc904c901043af07931f293c47"
    end
  end

  def install
    ENV["GOPATH"] = buildpath
    cfsslpath = buildpath/"src/github.com/cloudflare/cfssl"
    cfsslpath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/cloudflare/cfssl" do
      system "go", "build", "-o", "#{bin}/cfssl", "cmd/cfssl/cfssl.go"
      system "go", "build", "-o", "#{bin}/cfssljson", "cmd/cfssljson/cfssljson.go"
      system "go", "build", "-o", "#{bin}/cfssl-mkbundle", "cmd/mkbundle/mkbundle.go" # prefixing with 'cfssl-'; mono (et al.) also has a `mkbundle`
    end
  end

  def caveats; <<-EOS.undent
    The `mkbundle` utility has been installed as `cfssl-mkbundle` to prevent conflicts with other formulae.
    EOS
  end

  test do
    require "utils/json"
    (testpath/"request.json").write <<-EOS.undent
    {
      "CN" : "Your Certificate Authority",
      "hosts" : [],
      "key" : {
        "algo" : "rsa",
        "size" : 4096
      },
      "names" : [
        {
          "C" : "US",
          "ST" : "Your State",
          "L" : "Your City",
          "O" : "Your Organization",
          "OU" : "Your Certificate Authority"
        }
      ]
    }
    EOS
    shell_output("#{bin}/cfssl genkey -initca request.json > response.json")
    response = Utils::JSON.load(File.read(testpath/"response.json"))
    assert_match /^-----BEGIN CERTIFICATE-----.*/, response["cert"]
    assert_match /.*-----END CERTIFICATE-----$/, response["cert"]
    assert_match /^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"]
    assert_match /.*-----END RSA PRIVATE KEY-----$/, response["key"]
  end
end
