require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.9.tar.gz'
  mirror 'http://fossies.org/linux/misc/mercurial-2.9.tar.gz'
  sha1 '9b7d8259434f6aae29f6eee3dd5665b516857cf3'

  # The hg repo is a recursive dep - so build stable in-place then checkout.
  head do
    url 'http://mercurial.selenic.com/release/mercurial-2.9.tar.gz'
    sha1 '9b7d8259434f6aae29f6eee3dd5665b516857cf3'
  end

  # Pull in docutils to buildpath/doc for manpage. It's not installed.
  resource 'docutils' do
    url 'http://prdownloads.sourceforge.net/docutils/docutils-0.11.tar.gz'
    sha1 '3894ebcbcbf8aa54ce7c3d2c8f05460544912d67'
  end

  depends_on :python

  def install
    ENV.append 'CFLAGS', '-Qunused-arguments' if ENV.compiler == :clang
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    if build.head?
      # Move to parent directory of buildpath.
      mv Dir['*'], '..'
      cd '..' do
        buildpath.rmtree
        system 'python', 'setup.py', 'build_ext', '--inplace'
        system './hg', 'clone', 'http://selenic.com/repo/hg', buildpath
      end
    end

    (buildpath/'docutils').install resource('docutils')
    mv 'docutils/docutils', 'doc'

    system 'make', 'doc'
    system 'make', 'install', "PREFIX=#{prefix}"

    bin.install 'hgeditor'
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'
    zsh_completion.install 'contrib/zsh_completion' => '_hg'
  end

  test do
    system "#{bin}/hg", "debuginstall"
  end
end
