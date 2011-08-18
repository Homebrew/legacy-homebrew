require 'formula'

class Duplicity < Formula
  url 'http://launchpad.net/duplicity/0.6-series/0.6.14/+download/duplicity-0.6.14.tar.gz'
  homepage 'http://www.nongnu.org/duplicity/'
  md5 '09747eb1430a3f16888a661e5acbf28d'

  depends_on 'librsync'
  depends_on 'gnupg'

  def install
    ENV.universal_binary
    # Install mostly into libexec
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-purelib=#{libexec}",
                     "--install-platlib=#{libexec}",
                     "--install-scripts=#{bin}"

    # Shift files around to avoid needing a PYTHONPATH
    system "mv #{bin}/duplicity #{bin}/duplicity.py"
    system "mv #{bin}/* #{libexec}"
    # Symlink the executables
    ln_s "#{libexec}/duplicity.py", "#{bin}/duplicity"
    ln_s "#{libexec}/rdiffdir", "#{bin}/rdiffdir"
  end

  def patches
    # back-ported fix to ssh-backend. fixed in upstream for 0.6.15.
    # for issue-details see https://bugs.launchpad.net/duplicity/+bug/823556
    DATA
  end
end


__END__
--- 0.6.14/src/backends/sshbackend.py	2011-06-13 14:24:27 +0000
+++ 0.6.15-pre/src/backends/sshbackend.py	2011-08-17 14:21:15 +0000
@@ -278,6 +278,10 @@
         be distinguished from the file boundaries.
         """
         dirs = self.remote_dir.split(os.sep)
+        if len(dirs) > 0:
+            if not dirs[0] :
+                dirs = dirs[1:]
+                dirs[0]= '/' + dirs[0]
         mkdir_commands = [];
         for d in dirs:
             mkdir_commands += ["mkdir \"%s\"" % (d)] + ["cd \"%s\"" % (d)]
