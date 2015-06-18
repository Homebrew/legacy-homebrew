class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "http://packages.fanout.io/source/zurl-1.4.2.tar.bz2"
  sha256 "8c1ceb5fd7aad81b1b04323b46a742a2da6bbc63d825b847b23876d74a8162ab"

  bottle do
    cellar :any
    sha256 "1162e98e173d0e4a9aabaa454bf763fd43cf7d4ae91c60e6453965948e7ce74e" => :yosemite
    sha256 "6180d9e6c0847e69054b4e8e87e514bc8a5aa729f203dae4acbf9de774e7dd1f" => :mavericks
    sha256 "5218b780a805648f399d8f46f21ad02b37e985914e11cdd19d0b600e83b6fb60" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "curl" if MacOS.version < :lion
  depends_on "qt"
  depends_on "zeromq"
  depends_on "qjson"

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.6.0.tar.gz"
    sha256 "7746806ff94f1e8c1e843644c6bbd3b9aaeb1203c2eaf38879adc23dbd5c35bb"
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
