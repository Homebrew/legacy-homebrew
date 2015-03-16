class Pushpin < Formula
  homepage "http://pushpin.org"
  url "http://packages.fanout.io/source/pushpin-1.1.0.tar.bz2"
  sha1 "4cf4d061062a37f3ff8fa53706523e8f61c79c08"

  bottle do
    sha256 "da47c1945de1c2568f137e90a2bdb037fc63b9c85e8c2111ea61e675df716647" => :yosemite
    sha256 "43381c8079e5ea1ecfaebcf142f05415d95908ac90ebe3c0f4313b814ddb64ff" => :mavericks
    sha256 "02159fc0a5a38c7d1e93223e1246c5a778707eb9a504c381a88b2909530049bf" => :mountain_lion
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
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.5.0.tar.gz"
    sha1 "1dced02ea8527b5870ffdbe835d096aca5c01d2a"
  end

  resource "setproctitle" do
    url "https://pypi.python.org/packages/source/s/setproctitle/setproctitle-1.1.8.tar.gz"
    sha1 "a23463feac8d99b5504efc22f0ca2cfe2c145930"
  end

  resource "tnetstring" do
    url "https://pypi.python.org/packages/source/t/tnetstring/tnetstring-0.2.1.tar.gz"
    sha1 "ffc35722f4ae978151acdc4801f20efa597c8b54"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    %w[MarkupSafe jinja2 pyzmq setproctitle tnetstring].each do |r|
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
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
