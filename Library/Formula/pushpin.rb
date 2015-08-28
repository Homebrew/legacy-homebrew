class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "http://pushpin.org"
  url "https://dl.bintray.com/fanout/source/pushpin-1.5.0.tar.bz2"
  sha256 "9e9a05da706260bc4c96a36f9af5fdc38b78699709c83538663f00f59104ba2b"

  head "https://github.com/fanout/pushpin.git"

  bottle do
    cellar :any
    sha256 "5cf360e17906df91764cb18379a429eb9541974a6c8b8bcf961302dcef0c23d3" => :yosemite
    sha256 "bb470fe80c924be13c5f91cb3a597ddece614969df88fb79a7683b02dde7ea94" => :mavericks
    sha256 "901b72b2601c0702d60b27e3c36ed1f7b2099a2f3784fe73a468428532271181" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "zeromq"
  depends_on "qca"
  depends_on "qjson"
  depends_on "mongrel2"
  depends_on "zurl"

  # MacOS versions prior to Yosemite need the latest setuptools in order to compile dependencies
  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-17.0.tar.gz"
    sha256 "561b33819ef3da2bff89cc8b05fd9b5ea3caeb31ad588b53fdf06f886ac3d200"
  end

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

  resource "sortedcontainers" do
    url "https://pypi.python.org/packages/source/s/sortedcontainers/sortedcontainers-0.9.6.tar.gz"
    sha256 "bacaeb1c3e59c3083eec4d1198ba5625246c012e0342aafa46291632e8458dd3"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "make", "prefix=#{prefix}", "varprefix=#{var}"
    system "make", "install", "prefix=#{prefix}", "varprefix=#{var}"

    pyenv = { :PYTHONPATH => ENV["PYTHONPATH"] }
    %w[pushpin pushpin-handler pushpin-publish].each do |f|
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

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end
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
