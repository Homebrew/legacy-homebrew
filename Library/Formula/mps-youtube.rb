class MpsYoutube < Formula
  desc "Terminal-based YouTube player and downloader."
  homepage "https://github.com/np1/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.5.tar.gz"
  sha256 "74d196058c9369a3587f076cafb1ee15baeb6be1465e270f7de9d9830463c869"

  depends_on :python3

  resource "pafy" do
    url "https://github.com/mps-youtube/pafy/archive/v0.4.2.tar.gz"
    sha256 "d554d645f9d1e68e4f2b95c586a254fbcb1c4316320cbdec29b48039f496b8d5"
  end

  resource "youtube-dl" do
    url "https://github.com/rg3/youtube-dl/archive/2015.11.19.tar.gz"
    sha256 "ef1925d99d88432afeb02ebde94dec31c977725c4837ce86b7882fbf907f9c57"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[youtube-dl pafy]

    res.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "which", "mpsyt"
  end
end
