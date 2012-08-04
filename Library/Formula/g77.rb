require 'formula'

class StandardHomebrewLocation < Requirement
  def message; <<-EOS.undent
    hpc port of g77 won't work outside of /usr/local

    Because this uses pre-compiled binaries, it will not work if
    Homebrew is installed somewhere other than /usr/local
    EOS
  end
  def satisfied?
    HOMEBREW_PREFIX.to_s == "/usr/local"
  end
end

class G77 < Formula
  homepage 'http://hpc.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/hpc/hpc/g77/g77-intel-bin.tar.gz'
  version '3.4'
  sha1 '29c3846b91f84b8bf6d7253e8ebf944ee8de08f3'

  depends_on StandardHomebrewLocation.new

  def install
    safe_system "mv local/* #{prefix}"
  end
end
