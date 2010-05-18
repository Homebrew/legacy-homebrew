require 'formula'

class Ec2ApiTools <Formula
  @homepage='http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351'
  @url='http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.3-51254.zip'
  @md5='4644d3984009f576b1c34c6d60086e60'
  
  def patches
    # (From http://gist.github.com/200283) Gets rid of the
    # "[Deprecated] Xalan: org.apache.xml.res.XMLErrorResources_en_US"
    # messages that the tools spew on 1.3-41620 under Snow Leopard
    DATA
  end
  
  def install
    # Nothing to be done but copying things into place
    FileUtils.rm Dir['bin/*\.cmd']
    
    (prefix+bin).install Dir['bin/ec2-*']
    prefix.install 'lib'
  end
  
  def caveats
    return <<-EOS
Before you can utilize the EC2 API tools, you must export several environment
variables to your $SHELL. The easiest way to do this is to add them to your
dotfiles. If you're running the `bash` shell (the default), you'll want to add
them to `~/.bash_profile`. If this is the case, run `nano ~/.bash_profile` at
a terminal to edit said file. zsh users will want to edit `~/.zprofile`
instead.

    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home/"
    export EC2_HOME="#{prefix}/"

However, you're still not ready to use the tools. You need to download your
X.509 certificate and private key from Amazon Web Services. These files are
available at the following URL:

http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key

You should download two `.pem` files, one starting with `pk-`, and one
starting with `cert-`. You need to put both into a folder in your home
directory, `~/.ec2`, and then add the following to your profile file:

    export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
    export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"

    EOS
  end
  
end


__END__
diff --git i/bin/ec2-cmd w/bin/ec2-cmd
index 57051eb..edc2aae 100755
--- i/bin/ec2-cmd
+++ w/bin/ec2-cmd
@@ -58,4 +58,13 @@ fi
 
 CMD=$1
 shift
-"$JAVA_HOME/bin/java" $EC2_JVM_ARGS $cygprop -classpath "$CP" com.amazon.aes.webservices.client.cmd.$CMD "$@"
+
+# to filter out the "deprecated" warnings introduced by Snow Leopard...
+exec 3>&1   # ... redirect fd3 to stdout
+exec 4>&2   # ... redirect fd4 to stderr
+
+# ... execute the java, sending stderr to stdout (so it gets grepped), 
+#     but stdout goes to fd3 (the preserved real stdout)
+#     and the grepped output goes to fd4 (the preserved stderr)
+"$JAVA_HOME/bin/java" $EC2_JVM_ARGS $cygprop -classpath "$CP" com.amazon.aes.webservices.client.cmd.$CMD "$@" \
+    2>&1 >&3 | grep -v '^\[Deprecated\] Xalan' >&4
