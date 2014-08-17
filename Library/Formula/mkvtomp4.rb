require 'formula'

class Mkvtomp4 < Formula
  homepage 'https://github.com/gavinbeatty/mkvtomp4/'
  url 'https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v1.3.tar.gz'
  sha1 'eab345f40a2d6f30847300f8e2880354e08356d2'

  depends_on 'gpac'
  depends_on 'ffmpeg' => :recommended
  depends_on 'mkvtoolnix'
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', lib+'python2.7/site-packages'

    system "make"
    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.install "mkvtomp4.py" => "mkvtomp4"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
