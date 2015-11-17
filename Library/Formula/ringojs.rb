class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "http://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v0.11.0/ringojs-0.11.tar.gz"
  sha256 "aafccc75f41f1c6e78fbc270a4f1788c506f31a640b5fa23bacd77daadf11d27"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
