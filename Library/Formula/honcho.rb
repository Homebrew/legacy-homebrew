class Honcho < Formula
  homepage "https://github.com/nickstenning/honcho"
  url "https://pypi.python.org/packages/source/h/honcho/honcho-0.5.0.tar.gz"
  sha1 "c9f9bdaa59293f8c9ac515d55c9ee4a09240821d"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Procfile").write <<-EOS.undent
      talk: echo $MY_VAR
    EOS
    (testpath/".env").write <<-EOS.undent
      MY_VAR=hi
    EOS
    assert_match /talk\.\d+ | hi/, `#{bin}/honcho start`
  end
end
