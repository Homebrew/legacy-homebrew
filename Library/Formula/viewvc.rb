class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "http://viewvc.tigris.org/files/documents/3330/49471/viewvc-1.1.24.tar.gz"
  sha256 "0620f69fa5ba02ac65e000586ba31015a2053a82711bedb30629fd6087003d7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "389820a6f60d0977413ac7aebbf3bbacd2661cc105865813e5cf50c1f9f02020" => :el_capitan
    sha256 "06d3611ba9c051f0e5d51859c739c77a1bb2c6beb054008ca2a63db1c2f3a1f1" => :yosemite
    sha256 "8d76afcfed4be03aee5c35b83a389dd4174fc6dbc528386c1e9ba3dd4a7a575d" => :mavericks
  end

  # swig is a dependency of subversion --with-python, but due to a
  # bug it needs to also be specified here.
  # https://github.com/Homebrew/homebrew/issues/42915
  depends_on "swig" => :run
  depends_on "subversion" => "with-python"

  def install
    system "python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?
      bin.install_symlink f => "viewvc-#{f.basename}"
    end
  end

  test do
    require "net/http"
    require "uri"

    begin
      pid = fork { exec "#{bin}/viewvc-standalone.py", "--port=9000" }
      sleep 2
      uri = URI.parse("http://127.0.0.1:9000/viewvc")
      Net::HTTP.get_response(uri) # First request always returns 400
      assert_equal "200", Net::HTTP.get_response(uri).code
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
