class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://dl.bintray.com/fanout/source/zurl-1.5.0.tar.bz2"
  sha256 "102456174569d882c77dde80669c51bee4a418c5ed81a27ea15d7a0810d1a555"

  # ensure unit tests don't install on 1.5.0. remove after next release
  patch do
    url "https://github.com/fanout/zurl/commit/6f727e9e26054889ced261993e91f11dea3a1b5c.patch"
    sha256 "7fff340cec94d6c4883aacbf991ac97ee963e8628cda0ad3c67daddb759a26a9"
  end

  bottle do
    cellar :any
    sha256 "0a60f5c9d1d7e47e8b9ed72ddcc82a4e8dd45d3a731686e3194f91be0d948a64" => :el_capitan
    sha256 "4f3816d8d565b2ec24ec3607d2ce678cfcea5a131548e4dbba834a7f82110f6a" => :yosemite
    sha256 "752d05f0a4d681cf1c7e05972f502bda4b580fdc483779b6cd1709cde14282f9" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "curl" if MacOS.version < :lion
  depends_on "qt5"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-15.2.0.tar.gz"
    sha256 "2dafa322670a94e20283aba2a44b92134d425bd326419b68ad4db8d0831a26ec"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    resource("pyzmq").stage { system "python", *Language::Python.setup_install_args(testpath/"vendor") }

    conffile.write(<<-EOS.undent
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
      EOS
                  )

    runfile.write(<<-EOS.undent
      import json
      import threading
      from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
      import zmq
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write('test response\\n')
      port = None
      def server_worker(c):
        global port
        server = HTTPServer(('', 0), TestHandler)
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
      ctx = zmq.Context()
      sock = ctx.socket(zmq.REQ)
      sock.connect('ipc://#{ipcfile}')
      req = {'id': '1', 'method': 'GET', 'uri': 'http://localhost:%d/test' % port}
      sock.send('J' + json.dumps(req))
      poller = zmq.Poller()
      poller.register(sock, zmq.POLLIN)
      socks = dict(poller.poll(15000))
      assert(socks.get(sock) == zmq.POLLIN)
      resp = json.loads(sock.recv()[1:])
      assert('type' not in resp)
      assert(resp['body'] == 'test response\\n')
      EOS
                 )

    pid = fork do
      exec "#{bin}/zurl", "--config=#{conffile}"
    end

    begin
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
