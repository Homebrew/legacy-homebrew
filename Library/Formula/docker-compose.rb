class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"

  stable do
    url "https://github.com/docker/compose/archive/1.6.2.tar.gz"
    sha256 "1c318cdf12bdc97e079224fb0cab45ed0f6ec2d1ce87599eff549b1aafa27837"
  end

  bottle do
    cellar :any
    sha256 "2afc4f42c9415f9fb1d159176897f60bd80ad789b483ef6c7fb3d1c7b9b2bd68" => :el_capitan
    sha256 "ac436c343402cccf56426dfb90643e38cce25cd839b9ee76abd73cb079620217" => :yosemite
    sha256 "f62e352ec74218779fc6c7d9c3ac5f5f00d49f065b0d304de39cf17904f66caa" => :mavericks
  end

  head do
    url "https://github.com/docker/compose.git"
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.7.2.tar.gz"
    sha256 "95b1d14c4ae49dfbb724332cda9c63fb67628b8bdee79c321f2d405cf7a8d04c"
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

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha256 "e713da45c96ca53a3a8b48140d4120374db622df16ab71759c9ceb5b8d46fe7c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.7.3.tar.gz"
    sha256 "7a842c9f882c0b2ab1064d567bb9fff6a21c9efbc3d9992083ad6193787ed393"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.4.tar.gz"
    sha256 "8587b61cb6c6022d0eb79e56e59825df4353f0f33099b4ae3bcfe8d41bd1702e"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.1.tar.gz"
    sha256 "71ad940a773fbc23be6093e9476ad57b2ecec446946a28d30127501f3b29aa35"
  end

  resource "websocket-client" do
    url "https://github.com/liris/websocket-client/archive/v0.32.0.tar.gz"
    sha256 "255d07ffa677f571b5f51c11703f2f4bd5f331b58442677bcb4395dfa1809a5f"
  end

  resource "cached-property" do
    url "https://pypi.python.org/packages/source/c/cached-property/cached-property-1.2.0.tar.gz"
    sha256 "e3081a8182d3d4b7283eeade76c382bcfd4dfd644ca800598229c2ef798abb53"
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
  end

  test do
    assert_match /#{version}/, shell_output(bin/"docker-compose --version")
  end
end
