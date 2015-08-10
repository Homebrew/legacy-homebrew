class BzrFastimport < Formula
  desc "Bazaar plugin for fast loading of revision control"
  homepage "https://launchpad.net/bzr-fastimport"
  url "https://launchpad.net/bzr-fastimport/trunk/0.13.0/+download/bzr-fastimport-0.13.0.tar.gz"
  sha256 "5e296dc4ff8e9bf1b6447e81fef41e1217656b43368ee4056a1f024221e009eb"

  bottle do
    cellar :any
    sha256 "d72b41c0aad53a702677d75810369da2ad14a8006bfe46750de3ed2d98ddccbd" => :yosemite
    sha256 "74e3a541a5e6436475d886a0a438540c31249b9c5d4c48a9111239227a0f8b85" => :mavericks
    sha256 "e214595d2db088abe607c92f163eec3cf10118c52e00fbc5cf28c4440b33919c" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "bazaar"

  resource "python-fastimport" do
    url "https://launchpad.net/python-fastimport/trunk/0.9.0/+download/python-fastimport-0.9.0.tar.gz"
    sha256 "07d1d3800b1cfaa820b62c5a88c40cc7e32be9b14d9c6d3298721f32df8e1dec"
  end

  def install
    resource("python-fastimport").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    libexec.install Dir["*"]

    # The plugin must be symlinked in bazaar/plugins to work
    target = var/"bazaar/plugins/fastimport"
    # we need to remove the target before symlinking it because if we don't and
    # the symlink exists from a previous installation the new symlink will be
    # created inside libexec instead of overriding the previous one because ln
    # itself follows symlinks.
    rm_rf target if target.exist?
    ln_s libexec, target
  end

  def caveats; <<-EOS.undent
    In order to use this plugin you must set your PYTHONPATH in your ~/.bashrc:

      export PYTHONPATH="#{libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    bazaar = Formula["bazaar"]
    assert File.exist?(bazaar.libexec/"bzrlib/plugins/fastimport/__init__.py"),
      "The fastimport plugin must have been symlinked under bzrlib/plugins/"

    bzr = bazaar.bin/"bzr"
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    system bzr, "init"
    assert_match(/fastimport #{version}/,
                 shell_output("#{bzr} plugins --verbose"))
    system bzr, "fast-export", "--plain", "."
  end
end
