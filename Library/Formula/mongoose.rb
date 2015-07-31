class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/5.6.tar.gz"
  sha256 "cc2557c7cf9f15e1e691f285a4c6c705cc7e56cb70c64cb49703a428a0677065"

  bottle do
    cellar :any
    revision 2
    sha256 "158f24303e018ec3f9ee05d3ffe10a2399b700cfdf869e9fe2970f68105b1fe5" => :yosemite
    sha256 "53cbd378f59876d7922ba743c99dedc305707c13caeea0339667bf5006080b24" => :mavericks
    sha256 "e9ee23cf028f5be715fbae963cf661dffc9850b71039c90f2aae70e07c410fda" => :mountain_lion
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
    pkgshare.install "examples", "jni"
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
