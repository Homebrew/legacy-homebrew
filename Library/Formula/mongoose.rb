class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/5.6.tar.gz"
  sha256 "cc2557c7cf9f15e1e691f285a4c6c705cc7e56cb70c64cb49703a428a0677065"

  bottle do
    cellar :any
    revision 1
    sha256 "e3a80b68e0a50275295218d1400666cc079c24f39d2ae1f7a3b59fbd7e9c674d" => :yosemite
    sha256 "731126c1b98a2e42c593378881c7f8ed7d9b9b54720f6896ca5aedd5fba8819d" => :mavericks
    sha256 "ba1fc7d05e6c7afe5be544e7089c2e26dde5cdfde93c0128353be19081ed86db" => :mountain_lion
  end

  depends_on "openssl" => :recommended

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/blob/master/docs/Usage.md
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/web_server" do
      args = []
      args << "openssl" if build.with? "openssl"

      system "make", *args
      bin.install "web_server" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
    share.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<-EOS.undent
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hello World!</p>
        </body>
      </html>
    EOS

    pid = fork do
      exec "#{bin}/mongoose -document_root #{testpath} -index_files hello.html"
    end
    sleep 2

    begin
      assert_match /Hello World!/, shell_output("curl localhost:8080")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
