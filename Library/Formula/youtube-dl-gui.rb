class YoutubeDlGui < Formula
  desc "A cross platform front-end GUI of the popular youtube-dl."
  homepage "https://github.com/MrS0m30n3/youtube-dl-gui"
  url "https://github.com/MrS0m30n3/youtube-dl-gui.git",
    :revision => "95189d3d82c159e069697fa65058c8a9f88ff686"

  # cannot use git tag right now as new version with OSX support not released
  version "0.3.8"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "wxpython"
  depends_on "ffmpeg"

  resource "altgraph" do
    url "https://pypi.python.org/packages/source/a/altgraph/altgraph-0.12.tar.gz"
    sha256 "b90db0dba36d9ece282b6a95ae3d324b63239694ce2cf2fd07d3efd7f2f7cab2"
  end

  resource "macholib" do
    url "https://pypi.python.org/packages/source/m/macholib/macholib-1.7.tar.gz"
    sha256 "1865bed8c50131649653d82cd1fbeb73a36a51355c48c81debdc195387b8103a"
  end

  resource "modulegraph" do
    url "https://pypi.python.org/packages/source/m/modulegraph/modulegraph-0.12.1.tar.gz"
    sha256 "8b278c56f962883986b1a3c8b963ace017553e66fce06a523b59c15c971971a3"
  end

  resource "py2app" do
    url "https://pypi.python.org/packages/source/p/py2app/py2app-0.9.tar.gz"
    sha256 "7922672f9e99b50ed931780d43405ac134988b1532dd0659ef130b824f88c59d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[altgraph modulegraph macholib py2app].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
    system "python", "setup.py", "py2app"
    cp_r "dist/Youtube-DLG.app", "#{prefix}/YoutubeDlGui.app"
  end
end
