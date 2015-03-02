# Base classes for specialized types of formulae.

# See chcase for an example
class ScriptFileFormula < Formula
  def install
    bin.install Dir['*']
  end
end

# See browser for an example
class GithubGistFormula < ScriptFileFormula
  def self.url(val)
    super
    version File.basename(File.dirname(val))[0, 6]
  end
end

# This formula serves as the base class for several very similar
# formulae for Amazon Web Services related tools.
class AmazonWebServicesFormula < Formula
  # Use this method to peform a standard install for Java-based tools,
  # keeping the .jars out of HOMEBREW_PREFIX/lib
  def standard_install options={}
    java_version = options[:java]
    env = options[:env] || {}
    env.merge! Language::Java.java_home_env(java_version)
    rm Dir['bin/*.cmd'] # Remove Windows versions
    libexec.install Dir['*']
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?
      basename = file.basename
      next if basename.to_s == "service"
      (bin/basename).write_env_script file, env
    end
  end

  def install
    standard_install
  end

  # Use this method to generate standard caveats.
  def caveats
    <<-EOS.undent
      Before you can use these tools you must export some variables to your $SHELL.

      To export the needed variables, add them to your dotfiles.
       * On Bash, add them to `~/.bash_profile`.
       * On Zsh, add them to `~/.zprofile` instead.

      export AWS_ACCESS_KEY="<Your AWS Access ID>"
      export AWS_SECRET_KEY="<Your AWS Secret Key>"
      export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end
end
