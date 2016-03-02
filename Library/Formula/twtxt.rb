class Twtxt < Formula
  desc "Decentralised, minimalist microblogging service for hackers."
  homepage "https://github.com/buckket/twtxt"
  url "https://github.com/buckket/twtxt/archive/v1.2.1.tar.gz"
  sha256 "d16fe169b2f5800a60d2ed3d9b876e50fe45f2c0b46730d60a7b489bbc2c4e6a"

  depends_on :python3

  resource "aiohttp" do
    url "https://pypi.python.org/packages/source/a/aiohttp/aiohttp-0.21.2.tar.gz"
    sha256 "991e574309815036ca36889a8917005bb795522acd2ba9cc870e07c260c092b5"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.3.tar.gz"
    sha256 "b720d9faabe193287b71e3c26082b0f249501288e153b7e7cfce3bb87ac8cc1c"
  end

  resource "humanize" do
    url "https://pypi.python.org/packages/source/h/humanize/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.5.0.tar.gz"
    sha256 "c1f7a66b0021bd7b206cc60dd47ecc91b931cdc5258972dc56b25186fa9a96a5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/"config").write <<-EOS.undent
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      twtxt = https://buckket.org/twtxt_news.txt
    EOS
    (testpath/"twtxt.txt").write <<-EOS.undent
      2016-02-05T18:00:56.626750+00:00  Homebrew speaks!
    EOS
    assert_match "Fiat Lux!", shell_output("#{bin}/twtxt -c config timeline")
  end
end
