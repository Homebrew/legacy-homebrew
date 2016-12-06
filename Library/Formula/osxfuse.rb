require 'formula'

class Osxfuse < Formula
  homepage 'http://osxfuse.github.io/'
  version "2.6.0-2"
  url 'https://github.com/osxfuse/osxfuse.git', :revision => '941b777627e45debf4ef56505fef35dd732d9182'

  # Always use newer versions of these tools
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  depends_on 'gettext'

  fails_with :clang do
    cause <<-EOS.undent
      compile fails with cc
      EOS
  end

  def install
        system "bash", "build.sh", "-t", "homebrew", "-f", "/usr/local/Cellar/osxfuse/#{version}"
  end
end
