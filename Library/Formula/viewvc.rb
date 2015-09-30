class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "http://viewvc.tigris.org/files/documents/3330/49392/viewvc-1.1.23.tar.gz"
  sha256 "d14290b23f44e8f5301a7ca9fc946bcd0f8bb8206d9b9c111ac56e19f2588b7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "89041cf76c25bcc0c6ebf4a5991af5a5dc0d5cb0f436149d57d563e2401f20d8" => :el_capitan
    sha256 "77d7571e6a36dc12e5e34f06d1fa76caeb4f34d046689eef08656d6596987757" => :yosemite
    sha256 "56b8feafaa2282718d8db6a4612f58de01efdc0b86b62cb80e5715d5085c8a56" => :mavericks
  end

  # swig is a dependency of subversion --with-python, but due to a
  # bug it needs to also be specified here.
  # https://github.com/Homebrew/homebrew/issues/42915
  depends_on "swig" => :run
  depends_on "subversion" => "with-python"

  def install
    system "/usr/bin/python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?
      (bin/"viewvc-#{f.basename}").write_env_script f, :PYTHONPATH => "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
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
