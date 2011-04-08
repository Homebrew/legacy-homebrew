require 'formula'

# This formula serves as the base class for several very similar
# formulae for Amazon Web Services related tools.

class AmazonWebServicesFormula < Formula
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
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.4.2.2.zip'
  md5 'cdba94d87579823b4d043f629be338f0'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
