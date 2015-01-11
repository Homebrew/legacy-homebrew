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
  def install
    rm Dir['bin/*.cmd'] # Remove Windows versions
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/service"]
  end
  alias_method :standard_install, :install

  # Use this method to generate standard caveats.
  def standard_instructions home_name, home_value=libexec
    <<-EOS.undent
      Before you can use these tools you must export some variables to your $SHELL.

      To export the needed variables, add them to your dotfiles.
       * On Bash, add them to `~/.bash_profile`.
       * On Zsh, add them to `~/.zprofile` instead.

      export JAVA_HOME="$(/usr/libexec/java_home)"
      export AWS_ACCESS_KEY="<Your AWS Access ID>"
      export AWS_SECRET_KEY="<Your AWS Secret Key>"
      export #{home_name}="#{home_value}"
    EOS
  end
end

# This formula serves as the base class for several very similar
# formulae for Python related tools.
class PythonFormula < Formula
  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm "#{lib}/python2.7/site-packages/site.py"
    rm "#{lib}/python2.7/site-packages/easy-install.pth"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
