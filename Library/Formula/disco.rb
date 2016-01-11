class Disco < Formula
  desc "Distributed computing framework based on the MapReduce paradigm"
  homepage "http://discoproject.org/"
  url "https://github.com/discoproject/disco/archive/0.5.4.tar.gz"
  sha256 "a1872b91fd549cea6e709041deb0c174e18d0e1ea36a61395be37e50d9df1f8f"

  bottle do
    cellar :any
    sha256 "5c2cce9d23b29c1be6d5226eae384d8350b4bb490d6d548f10e66761f49cbd65" => :yosemite
    sha256 "2dc00048144e2faecd558a9db6af23c6bc95157445124f7b25790c6508ee2acc" => :mavericks
    sha256 "003628e6ba324264409fb54c457089ead2d1c2490565e6a52fd01f19f4ffbaed" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "erlang"
  depends_on "simplejson" => :python if MacOS.version <= :leopard
  depends_on "libcmph"

  # Modifies config for single-node operation
  patch :DATA

  conflicts_with "mono", :because => "both install `disco` binaries"

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"

    inreplace "Makefile" do |s|
      s.change_make_var! "prefix", prefix
      s.change_make_var! "sysconfdir", etc
      s.change_make_var! "localstatedir", var
    end

    # Disco's "rebar" build tool refuses to build unless it's in a git repo, so
    # make a dummy one
    system "git init && git add master/rebar && git commit -a -m 'dummy commit'"

    system "make"
    system "make", "install"
    prefix.install %w[contrib doc examples]

    # Fix the config file to point at the linked files, not in to cellar
    # This isn't ideal - if there's a settings.py file left over from a previous disco
    # installation, it'll issue a Warning
    inreplace "#{etc}/disco/settings.py" do |s|
      s.gsub!("Cellar/disco/"+version+"/", "")
    end

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    <<-EOS.undent
      Please copy #{etc}/disco/settings.py to ~/.disco and edit it if necessary.
      The DDFS_*_REPLICA settings have been set to 1 assuming a single-machine install.
      Please see http://discoproject.org/doc/disco/start/install.html for further instructions.
    EOS
  end

  test do
    system "#{bin}/disco"
  end
end

__END__
diff -rupN disco-0.4.5/conf/gen.settings.sh my-edits/disco-0.4.5/conf/gen.settings.sh
--- disco-0.4.5/conf/gen.settings.sh  2013-03-28 12:21:30.000000000 -0400
+++ my-edits/disco-0.4.5/conf/gen.settings.sh 2013-04-10 23:10:00.000000000 -0400
@@ -23,8 +23,11 @@ DISCO_PORT = 8989
 # DISCO_PROXY_ENABLED = "on"
 # DISCO_HTTPD = "/usr/sbin/varnishd -a 0.0.0.0:\$DISCO_PROXY_PORT -f \$DISCO_PROXY_CONFIG -P \$DISCO_PROXY_PID -n/tmp -smalloc"

-DDFS_TAG_MIN_REPLICAS = 3
-DDFS_TAG_REPLICAS     = 3
-DDFS_BLOB_REPLICAS    = 3
+# Settings appropriate for single-node operation
+DDFS_TAG_MIN_REPLICAS = 1
+DDFS_TAG_REPLICAS     = 1
+DDFS_BLOB_REPLICAS    = 1
+
+DISCO_MASTER_HOST     = "localhost"

 EOF
