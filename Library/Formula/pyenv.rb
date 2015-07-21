class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/yyuu/pyenv"
  head "https://github.com/yyuu/pyenv.git"
  url "https://github.com/yyuu/pyenv/archive/v20150719.tar.gz"
  sha256 "9efb0f615f024d9bb1d7b29e7ce74932613c6ddedc5c78d4b19853a685af23ac"

  bottle do
    sha256 "4329cb2fe1704fcdfbcd29aecc7f9c29f0e847ace828fc998987e8ab8a209ce2" => :yosemite
    sha256 "503fe24120aeac8b99be1e3c130e3523b9273e8e6045b3fad0d0c031c3fd13e8" => :mavericks
    sha256 "4391ec605642bd2f9433c749c1aecaf1d4c4c5124ebac4097d2aa2fe6480cc57" => :mountain_lion
  end

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/pyenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    rm_f "#{var_lib}/plugins/python-build"
    ln_sf "#{prefix}/default-plugins/python-build", "#{var_lib}/plugins/python-build"
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/python-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

    To use Homebrew's directories rather than ~/.pyenv add to your profile:
      export PYENV_ROOT=#{var}/pyenv
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
