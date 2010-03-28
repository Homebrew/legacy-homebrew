# Author:: Joshua Timberman <joshua@opscode.com>

require 'formula'

class Runit <Formula
  url 'http://smarden.org/runit/runit-2.1.1.tar.gz'
  homepage 'http://smarden.org/runit'
  md5 '8fa53ea8f71d88da9503f62793336bc3'

  def install
    # Runit untars to 'admin/runit-VERSION'
    Dir.chdir("runit-2.1.1")

    # Per the installation doc on OS X, we need to make a couple changes.
    system "echo 'cc -Xlinker -x' >src/conf-ld"
    inreplace 'src/Makefile', / -static/, ''

    # TODO: Is there a way to pass 'var' to the patch?
    inreplace 'src/sv.c', /HOMEBREW_VAR/, var
    system "package/compile"

    # The commands are compiled and copied into the 'command' directory and
    # names added to package/commands. Read the file for the commands and
    # install them in homebrew.
    rcmds = File.open("package/commands").read
    rcmds.each do |r|
      bin.install("command/#{r.chomp}")
      man8.install("man/#{r.chomp}.8")
    end
    (var + "service").mkpath
  end

  def man8; man+'man8' end

  def caveats
    <<-END_CAVEATS
This formula does not install runit as a replacement for init.

The service directory is #{var}/service instead of /service.

To have runit ready to run services, start runsvdir:

    $ runsvdir -P #{var}

Depending on the services managed by runit, this may need to start as root.
    END_CAVEATS
  end

  def patches
    # Patch the service directory to live in /var instead of default.
    # TODO: include patching for the man pages too.
    DATA
  end
end

__END__
diff --git a/runit-2.1.1/src/sv.c b/runit-2.1.1/src/sv.c
index e27ccb2..7c07101 100644
--- a/runit-2.1.1/src/sv.c
+++ b/runit-2.1.1/src/sv.c
@@ -32,7 +32,7 @@
 char *progname;
 char *action;
 char *acts;
-char *varservice ="/service/";
+char *varservice ="HOMEBREW_VAR/service/";
 char **service;
 char **servicex;
 unsigned int services;

