class Pushpin < Formula
  homepage "http://pushpin.org"
  url "http://packages.fanout.io/source/pushpin-1.2.0.tar.bz2"
  sha256 "10156a5c3a5e956569fe25d5e467e3e452fc2b6b0b63c7894fc7f6aee6c7c414"

  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "a90c8d52613518a72afc8aae4e52131fe71c835cd01720fca732d3a956ff0bcc" => :yosemite
    sha256 "2528a22c7f714187391d036ec982bcd3fa0328d6e86ad5b9d6a18a2b921737ba" => :mavericks
    sha256 "7cf2530e048da5c1d06396487edee8bda9e592a53fa1f837eb6e7225e1b6847b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "zeromq"
  depends_on "qca"
  depends_on "qjson"
  depends_on "mongrel2"
  depends_on "zurl"

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.6.0.tar.gz"
    sha256 "7746806ff94f1e8c1e843644c6bbd3b9aaeb1203c2eaf38879adc23dbd5c35bb"
  end

  resource "setproctitle" do
    url "https://pypi.python.org/packages/source/s/setproctitle/setproctitle-1.1.8.tar.gz"
    sha256 "b564cf6488217c7a4632a9fe646fc3a3bea2f9712b4e667e9632b870d1a58211"
  end

  resource "tnetstring" do
    url "https://pypi.python.org/packages/source/t/tnetstring/tnetstring-0.2.1.tar.gz"
    sha256 "55715a5d758214034db179005def47ed842da36c4c48e9e7ae59bcaffed7ca9b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    %w[MarkupSafe Jinja2 pyzmq setproctitle tnetstring].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "make", "prefix=#{prefix}", "varprefix=#{var}"
    system "make", "install", "prefix=#{prefix}", "varprefix=#{var}"

    pyenv = { :PYTHONPATH => ENV["PYTHONPATH"] }
    %w[pushpin pushpin-handler].each do |f|
      (libexec/"bin").install bin/f
      (bin/f).write_env_script libexec/"bin/#{f}", pyenv
    end
  end

  test do
    conffile = testpath/"pushpin.conf"
    routesfile = testpath/"routes"
    runfile = testpath/"test.py"

    cp prefix/"etc/pushpin/pushpin.conf", conffile
    cp prefix/"etc/pushpin/internal.conf", testpath/"internal.conf"
    cp prefix/"etc/pushpin/routes", routesfile

    inreplace routesfile, "localhost:80", "localhost:10080"

    runfile.write <<-EOS.undent
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

    pid = fork do
      exec "#{bin}/pushpin", "--config=#{conffile}"
    end

    begin
      sleep 3 # make sure pushpin processes have started
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
