# Base classes for specialized types of formulae.

# See chcase for an example
class ScriptFileFormula < Formula
  def install
    bin.install Dir['*']
  end

  def self.method_added method
    super method
    case method
    when :install
      opoo "#{name}: if you are overriding ScriptFileFormula#install, use a Formula instead"
    end
  end
end

# See browser for an example
class GithubGistFormula < ScriptFileFormula
  def initialize name='__UNKNOWN__', path=nil
    url = self.class.stable.url
    self.class.stable.version(File.basename(File.dirname(url))[0,6])
    super
  end
end

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
  def standard_instructions var_name, var_value=linked_keg+'jars'
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

      export JAVA_HOME="$(/usr/libexec/java_home)"
      export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
      export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
      export #{var_name}="#{var_value}"
    EOS
  end
end
