require "formula"

class Cheat < Formula
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.0.5.tar.gz"
  sha1 "0a0b229b13e6f9d6c4ba0ae6ae0093546a565c28"
  head "https://github.com/chrisallenlane/cheat.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.1.tar.gz"
    sha1 "3d0ad1cf495d2c801327042e02d67b4ee4b85cd4"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
  end

  # Make the patch so that cheat wouldn't install shell completion into the system
  patch :DATA

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    %w[docopt Pygments].each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/_cheat.zsh" => "_cheat"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats;<<-EOS.undent
    Personal cheatsheets are saved in the ~/.cheat directory by default, but you
    can specify a different default by exporting a DEFAULT_CHEAT_DIR environment
    variable:
      export DEFAULT_CHEAT_DIR=/path/to/my/cheats

    To enable syntax highlighting, add the following line to your profile:
      export CHEATCOLORS=true
    EOS
  end

  test do
    system "#{bin}/cheat", "--version"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 72eec5d..8c443e3 100644
--- a/setup.py
+++ b/setup.py
@@ -2,9 +2,6 @@ from distutils.core import setup
 import os
 
 data = [
-       ('/usr/share/zsh/site-functions', ['cheat/autocompletion/_cheat.zsh']),
-       ('/etc/bash_completion.d'       , ['cheat/autocompletion/cheat.bash']),
-       ('/usr/share/fish/completions'  , ['cheat/autocompletion/cheat.fish'])
        ]
 
 if os.name == 'nt':
