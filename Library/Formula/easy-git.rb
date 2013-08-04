require 'formula'

# Force use of SSL3
# Similar to https://github.com/mxcl/homebrew/issues/20991
class CurlSSL3DownloadStrategy < CurlDownloadStrategy
  def _fetch
    curl @url, '-3', '-C', downloaded_size, '-o', @temporary_path
  end
end

class EasyGit < Formula
  homepage 'http://people.gnome.org/~newren/eg/'
  url 'https://people.gnome.org/~newren/eg/download/1.7.5.2/eg',
    :using => CurlSSL3DownloadStrategy
  version "1.7.5.2"
  sha1 'c59a10affaae79bddbbe1de743d85d7771575905'

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
