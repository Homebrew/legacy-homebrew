class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v0.6.6.tar.gz"
  sha256 "02703190e9775c899045e25e7f5b5b1a3b3ec1a4720d6b85a50da680f7f750c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bafc65b2e1502c59e4535bfb4e97f93bb56ead0d5ede190091ea68ab7e1faee" => :el_capitan
    sha256 "7b404c291672f7fab907c3aa5ad3ed1e53563b7e6d54512f5a8e7342ac393fdb" => :yosemite
    sha256 "b1e3e387daaf6eb4afa04c89f7563751635d02745e37e64ea7bf0afb3d7ea2b6" => :mavericks
    sha256 "b61af36df3f0228ffb78380bab1823e9a0d67d2c05ad14c37b43a1b5e41d0d0d" => :mountain_lion
  end

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
