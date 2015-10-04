class Mkvtomp4 < Formula
  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v1.3.tar.gz"
  sha256 "cc644b9c0947cf948c1b0f7bbf132514c6f809074ceed9edf6277a8a1b81c87a"

  depends_on "gpac"
  depends_on "ffmpeg" => :recommended
  depends_on "mkvtoolnix"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"

    system "make"
    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.install "mkvtomp4.py" => "mkvtomp4"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
