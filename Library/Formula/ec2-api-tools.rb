require 'formula'

# This formula serves as the base class for several very similar
# formulae for Amazon Web Services related tools.

class AmazonWebServicesFormula <Formula
  # Use this method to peform a standard install for Java-based tools,
  # keeping the .jars out of HOMEBREW_PREFIX/lib
  def standard_install
    rm Dir['bin/*.cmd'] # Remove Windows versions
    prefix.install "bin"
    # Put the .jars in prefix/jars/lib, which isn't linked to the Cellar
    # This will prevent conflicts with other versions of these jars.
    (prefix+'jars').install 'lib'
    (prefix+'jars/bin').make_symlink '../bin'
  end

  # Use this method to generate standard caveats.
  def standard_instructions var_name, var_value=prefix+'jars'
    <<-EOS.undent
      Before you can use these tools you must export some variables to your $SHELL
      and download your X.509 certificate and private key from Amazon Web Services.

      Your certificate and private key are available at:
      http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key

      Download two ".pem" files, one starting with `pk-`, and one starting with `cert-`.
      You need to put both into a folder in your home directory, `~/.ec2`.

      To export the needed variables, add them to your dotfiles.
       * On Bash, add them to `~/.bash_profile`.
       * On Zsh, add them to `~/.zprofile` instead.

      export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
      export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
      export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
      export #{var_name}="#{var_value}"
    EOS
  end
end

class Ec2ApiTools <AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.3-51254.zip'
  md5 '4644d3984009f576b1c34c6d60086e60'

  def patches
    # Gets rid of the "[Deprecated] Xalan: org.apache.xml.res.XMLErrorResources_en_US"
    # messages that the tools spew on 1.3-41620 under Snow Leopard
    # See: http://gist.github.com/200283
    DATA
  end

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
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
