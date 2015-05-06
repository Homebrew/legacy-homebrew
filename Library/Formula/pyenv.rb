class Pyenv < Formula
  homepage "https://github.com/yyuu/pyenv"
  head "https://github.com/yyuu/pyenv.git"
  url "https://github.com/yyuu/pyenv/archive/v20150404.tar.gz"
  sha256 "b7a2b2ef247e9ad66fb34985239fb0f40930bb924f091901475ef4b0731d1152"

  bottle do
    sha256 "79a8e03546564c1da30737aab388bca75b8be8fcc08943b10aa3454fdc3c80d1" => :yosemite
    sha256 "c419780d84fde1c1d3d3920d9ced82420a035bb8e29d81cc24ca872a8c0ea942" => :mavericks
    sha256 "9cf141e71308eb9718350dd0e70d40f2a740b6896ee0b1936363b5bff21df3d6" => :mountain_lion
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
