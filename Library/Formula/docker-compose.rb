class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"

  stable do
    url "https://github.com/docker/compose/archive/1.4.2.tar.gz"
    sha256 "cc11f8281f0cf99fcb5502edb6e0d49caca26f4a11570b8ad68943bd3a97dd5c"

    resource "docker-py" do
      url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.3.1.tar.gz"
      sha256 "743f3fc78f6159d14ac603def6470cf1b4edefc04de8b1ad8c349b380b503f50"
    end

    resource "requests" do
      url "https://pypi.python.org/packages/source/r/requests/requests-2.6.1.tar.gz"
      sha256 "490b111c824d64b84797a899a4c22618bbc45323ac24a0a0bb4b73a8758e943c"
    end
  end

  bottle do
    cellar :any
    sha256 "0043401413f6f6f6f6f3d2b92249811fe76e4e9010e5bebc1206ff3e9ceec050" => :el_capitan
    sha256 "b52f5bb056653319af678de1666f837c7343b68abfae740476d3e531240b2939" => :yosemite
    sha256 "6f147ec9b658d62fc80ccf31cf6984d7a749211dfa801e48ae02ca4bf0907195" => :mavericks
  end

  head do
    url "https://github.com/docker/compose.git"

    resource "docker-py" do
      url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.4.0.tar.gz"
      sha256 "933bd55ec332adfe69b2825d81e7d238f51d970d5b16f63a14199789cd04c7b8"
    end

    resource "requests" do
      url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
      sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
    end

    resource "enum34" do
      url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
      sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
    end

    resource "jsonschema" do
      url "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
      sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
    end

    resource "functools32" do
      url "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz"
      sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
    end
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.3.4.tar.gz"
    sha256 "a51044cc49089a2408fdf6769a63eebe0b16d91f34716ecee681984446ce467d"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.3.tar.gz"
    sha256 "f333ac915e7c5daddc7d4877b096beafe74ea88b4b746f82a4b110f84e348701"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "websocket-client" do
    url "https://github.com/liris/websocket-client/archive/v0.32.0.tar.gz"
    sha256 "255d07ffa677f571b5f51c11703f2f4bd5f331b58442677bcb4395dfa1809a5f"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    ln_s bin/"docker-compose", bin/"fig"
  end

  test do
    assert_match /#{version}/, shell_output(bin/"docker-compose --version")
  end
end
