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
  url 'https://people.gnome.org/~newren/eg/download/1.7.3/eg',
    :using => CurlSSL3DownloadStrategy
  version "1.7.3"
  sha1 'd17165c20ea1b3887f1f81ec6d1217727b817409'

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
