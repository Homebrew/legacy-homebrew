class Nodeenv < Formula
  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://pypi.python.org/packages/source/n/nodeenv/nodeenv-0.13.6.tar.gz"
  sha256 "feaafb0486d776360ef939bd85ba34cff9b623013b13280d1e3770d381ee2b7f"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"nodeenv", "--node=0.10.40", "--prebuilt", "env-0.10.40-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures corrent Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-0.10.40-prebuilt/bin"

    path = testpath/"test.js"
    path.write "console.log('hello');"
    assert_match /hello/, shell_output("node #{path}")
    assert_match /v0.10.40/, shell_output("node -v")
  end
end
