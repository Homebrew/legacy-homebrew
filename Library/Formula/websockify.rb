class Websockify < Formula
  desc "Websockify allows the tunnelling of TCP traffic over WebSockets"
  homepage "https://github.com/kanaka/websockify"
  url "https://github.com/kanaka/websockify/archive/v0.6.0.tar.gz"
  sha256 "aeb1bb0079696611045d2f188f38b68c8a4cc50e3c229db9156806c0078d608e"

  if MacOS.version <= :snow_leopard
    depends_on :python
    depends_on "numpy" => :python
  end
  depends_on "openssl"

  def install
    system "make"
    system "make", "-C", "other"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Install C version of websockify
    bin.install "other/websockify" => "websockify-c"

    man1.install "docs/websockify.1" => "websockify.1"

    (doc+"websockify").install "docs"

    # Upstream Bug: Not named ".dylib"
    # Issue: https://github.com/kanaka/websockify/issues/156
    lib.install "rebind.so" => "rebind.dylib"

    # rmdir, not rm_r, as this is genuinely empty and we want to fail if the tarball
    # ever changes in a new release
    rmdir "include/web-socket-js-project"

    (share+"websockify"+"client").install "wsirc.html", "wstelnet.html", "include"

    (share+"websockify").install "other/js" => "node-js"

    (share+"websockify"+"ruby").install "other/websocket.rb", "other/websockify.rb"

    (share+"websockify"+"clojure").install "other/project.clj", "other/websockify.clj"

    # Binaries not installed in bin (as bin.install ):-
    # - rebind: coding of discovery of rebind.so needs re-writing
    # - other/wswrap: dependency wswrapper.so seems to be missing
    # - other/launch.sh: coding of path discovery of dependencies is just too weird to work
    (share+"websockify"+"scripts").install "rebind", "other/wswrap" => "wswrap", "other/launch.sh" => "launch.sh"
  end

  # This test will fail if either of the ports 50000 or 500001 are in use
  test do
    system "websockify", "--timeout=1", "127.0.0.1:50000", "127.0.0.1:50001"
  end
end
