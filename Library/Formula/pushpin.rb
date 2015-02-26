class Pushpin < Formula
  homepage "http://pushpin.org"
  url "http://packages.fanout.io/source/pushpin-1.0.0.tar.bz2"
  sha1 "6862c69eda7eef2e7fc8dd15d9800a3b21792acd"

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "zeromq"
  depends_on "qca"
  depends_on "qjson"
  depends_on "mongrel2"
  depends_on "zurl"

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.5.0.tar.gz"
    sha1 "1dced02ea8527b5870ffdbe835d096aca5c01d2a"
  end

  resource "setproctitle" do
    url "https://pypi.python.org/packages/source/s/setproctitle/setproctitle-1.1.8.tar.gz"
    sha1 "a23463feac8d99b5504efc22f0ca2cfe2c145930"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "tnetstring" do
    url "https://pypi.python.org/packages/source/t/tnetstring/tnetstring-0.2.1.tar.gz"
    sha1 "ffc35722f4ae978151acdc4801f20efa597c8b54"
  end

  def install
    resource("pyzmq").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    resource("setproctitle").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    resource("jinja2").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    resource("tnetstring").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }

    inreplace "Makefile", /^prefix.*/, "prefix = #{prefix}"
    inreplace "Makefile", /^varprefix.*/, "varprefix = #{prefix}/var"

    inreplace "pushpin", /^import sys$/, "import sys\nsys.path.insert(0, '#{libexec/"vendor/lib/python2.7/site-packages"}')"
    inreplace "handler/pushpin-handler", /^import sys$/, "import sys\nsys.path.insert(0, '#{libexec/"vendor/lib/python2.7/site-packages"}')"

    system "make"
    system "make", "install"
  end

  test do
    conffile = testpath/"pushpin.conf"
    routesfile = testpath/"routes"
    runfile = testpath/"test.py"

    system "cp", prefix/"etc/pushpin/pushpin.conf", conffile
    system "cp", prefix/"etc/pushpin/internal.conf", testpath/"internal.conf"
    system "cp", prefix/"etc/pushpin/routes", routesfile

    inreplace routesfile, "localhost:80", "localhost:10080"

    runfile.write(<<-EOS.undent
      import urllib2
      import threading
      from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write('test response\\n')
      def server_worker(c):
        global port
        server = HTTPServer(('', 10080), TestHandler)
        port = server.server_address[1]
        c.acquire()
        c.notify()
        c.release()
        try:
          server.serve_forever()
        except:
          server.server_close()
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      f = urllib2.urlopen('http://localhost:7999/test')
      body = f.read()
      assert(body == 'test response\\n')
      EOS
      )

    pid = fork do
      exec "#{bin}/pushpin", "--config=#{conffile}"
    end

    begin
      sleep 3 # make sure pushpin processes have started
      ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
