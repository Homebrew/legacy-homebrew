class BzrFastimport < Formula
  desc "Bazaar plugin for fast loading of revision control"
  homepage "https://launchpad.net/bzr-fastimport"
  url "https://launchpad.net/bzr-fastimport/trunk/0.13.0/+download/bzr-fastimport-0.13.0.tar.gz"
  sha256 "5e296dc4ff8e9bf1b6447e81fef41e1217656b43368ee4056a1f024221e009eb"
  revision 1

  bottle do
    cellar :any
    sha256 "d72b41c0aad53a702677d75810369da2ad14a8006bfe46750de3ed2d98ddccbd" => :yosemite
    sha256 "74e3a541a5e6436475d886a0a438540c31249b9c5d4c48a9111239227a0f8b85" => :mavericks
    sha256 "e214595d2db088abe607c92f163eec3cf10118c52e00fbc5cf28c4440b33919c" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "bazaar"

  resource "python-fastimport" do
    url "https://launchpad.net/python-fastimport/trunk/0.9.2/+download/python-fastimport-0.9.2.tar.gz"
    sha256 "fd60f1173e64a5da7c5d783f17402f795721b7548ea3a75e29c39d89a60f261e"
  end

  def install
    resource("python-fastimport").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    (share/"bazaar/plugins/fastimport").install Dir["*"]
  end

  def caveats; <<-EOS.undent
    In order to use this plugin you must set your PYTHONPATH in your ~/.bashrc:

      export PYTHONPATH="#{opt_libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    bzr = Formula["bazaar"].bin/"bzr"
    system bzr, "init"
    assert_match(/fastimport #{version}/,
                 shell_output("#{bzr} plugins --verbose"))
    system bzr, "fast-export", "--plain", "."
  end
end
