class Autojump < Formula
  homepage "https://github.com/joelthelion/autojump"
  url "https://github.com/joelthelion/autojump/archive/release-v22.2.2.tar.gz"
  sha1 "d23d482077049fb07dcdc1e7764694f95937db24"

  head "https://github.com/joelthelion/autojump.git"

  # This patch applies to v22.2.2. The patch has been submitted to the upstream.
  patch :DATA

  def install
    system "./install.py", "-d", prefix, "-z", zsh_completion

    libexec.mkpath
    mv bin, libexec/"bin"
    bin.write_exec_script libexec/"bin/autojump"
  end

  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [[ -s `brew --prefix`/etc/profile.d/autojump.sh ]] && . `brew --prefix`/etc/profile.d/autojump.sh

    If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
      if test -f /usr/local/share/autojump/autojump.fish; . /usr/local/share/autojump/autojump.fish; end
    EOS
  end
end

__END__
diff --git a/install.py b/install.py
index 09fd557..039c6a2 100755
--- a/install.py
+++ b/install.py
@@ -29,13 +29,13 @@ def mkdir(path, dryrun=False):
         os.makedirs(path)
 
 
-def modify_autojump_sh(etc_dir, dryrun=False):
+def modify_autojump_sh(etc_dir, share_dir, dryrun=False):
     """Append custom installation path to autojump.sh"""
     custom_install = "\
         \n# check custom install \
         \nif [ -s %s/autojump.${shell} ]; then \
             \n\tsource %s/autojump.${shell} \
-        \nfi\n" % (etc_dir, etc_dir)
+        \nfi\n" % (share_dir, share_dir)
 
     with open(os.path.join(etc_dir, 'autojump.sh'), 'a') as f:
         f.write(custom_install)
@@ -207,7 +207,7 @@ def main(args):
         cp('./bin/_j', zshshare_dir, args.dryrun)
 
         if args.custom_install:
-            modify_autojump_sh(etc_dir, args.dryrun)
+            modify_autojump_sh(etc_dir, share_dir, args.dryrun)
 
     show_post_installation_message(etc_dir, share_dir, bin_dir)
 
