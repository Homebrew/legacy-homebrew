require 'formula'


class TigHeadDownloadStrategy < GitDownloadStrategy
  def stage
    #copy everything so that .git is included and install-release-doc works
    cp_r Dir[@clone+"{.}"], Dir.pwd
  end

  def support_depth?
    # prevent --depth 1 on git clones, so that make install-release-doc* works
    return false
  end
end

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.1.tar.gz'
  sha1 'de37817e6b53e91b5a8949a5080daf45478bd45f'

  head 'https://github.com/jonas/tig.git', :using => TigHeadDownloadStrategy

  depends_on :automake if build.head?

  def install

    ENV.deparallelize if build.head? # Parallel compilation fails with HEAD

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"

    system "make install"

    if build.head?
      # To avoid having to install a bunch of dependencies for building
      # man pages and html docs, use the latest release docs.
      system "make install-release-doc"
    else
      system "make install-doc-man"
      doc.install Dir['*.html']
    end

    bash_completion.install 'contrib/tig-completion.bash'
  end
end
