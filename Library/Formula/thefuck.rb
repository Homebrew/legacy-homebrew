class Thefuck < Formula
  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-3.4.tar.gz"
  sha256 "4e1a6e8ea154d7aae67f0935e5eeab1b243451a5537b70e919fec6f823a680b6"

  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea900ff0423a690981f7b76fa6d34f1ef167748a11db1c1e56dfa42d7c9b4175" => :el_capitan
    sha256 "2faf3b98004bab4161264b29c83cf3cb80e02779e0f6ebb2df82956301e9e3af" => :yosemite
    sha256 "e4ae4a088558bbed9dfda1a77f668bb0da68df76b4d1244ee5730cbdb1734f4a" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-3.2.1.tar.gz"
    sha256 "7f6bea8bfe2e5cfffd0f411aa316e837daadced1893b44254bb9a38a654340f7"
  end

  resource "pathlib" do
    url "https://pypi.python.org/packages/source/p/pathlib/pathlib-1.0.1.tar.gz"
    sha256 "6940718dfc3eff4258203ad5021090933e5c04707d5ca8cc9e73c94a7894ea9f"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-18.2.tar.gz"
    sha256 "0994a58df27ea5dc523782a601357a2198b7493dcc99a30d51827a23585b5b1d"
  end

  resource "decorator" do
    url "https://pypi.python.org/packages/source/d/decorator/decorator-4.0.2.tar.gz"
    sha256 "1a089279d5de2471c47624d4463f2e5b3fc6a2cf65045c39bf714fc461a25206"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-8.0.3.tar.gz"
    sha256 "30f98b66f3fe1069c529a491597d34a1c224a68640c82caf2ade5f88aa1405e8"
  end

  # FIXME: Remove this patch in 3.5!
  #
  # Patch sent to upstream: https://github.com/nvbn/thefuck/pull/473
  #
  # Why this patch is needed: when switching to/from a virtualenv while using
  # this software might turn its cache file incompatible between system's and
  # virtualenv's Python. The database packages used when creating and reading
  # the cache file must be the very same. If this package – e.g. gdbm – isn't
  # available – mostly when using system's Python – an ImportError is raised.
  patch :DATA

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[setuptools pathlib psutil colorama six decorator pip].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile, .bashrc or .zshrc:

      PYTHONIOENCODING="UTF-8"
      export PYTHONIOENCODING
      eval "$(thefuck --alias)"

    For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"
    assert_match /The Fuck #{version} using Python [0-9\.]+/, shell_output("#{bin}/thefuck --version 2>&1").chomp
    assert_match /.+TF_ALIAS.+thefuck.+/, shell_output("#{bin}/thefuck --alias").chomp
    assert_match /git branch/, shell_output("#{bin}/thefuck git branchh").chomp
    assert_match /echo ok/, shell_output("#{bin}/thefuck echho ok").chomp
    assert_match /^Seems like .+fuck.+ alias isn't configured.+/, shell_output("#{bin}/fuck").chomp
  end
end

__END__
diff --git a/thefuck/utils.py b/thefuck/utils.py
index b1bbd42..4ae5898 100644
--- a/thefuck/utils.py
+++ b/thefuck/utils.py
@@ -228,7 +228,7 @@ def cache(*depends_on):
                     value = fn(*args, **kwargs)
                     db[key] = {'etag': etag, 'value': value}
                     return value
-        except shelve_open_error:
+        except (shelve_open_error, ImportError):
             # Caused when going from Python 2 to Python 3 and vice-versa
             warn("Removing possibly out-dated cache")
             os.remove(cache_path)
