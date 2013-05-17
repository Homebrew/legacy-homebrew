require 'formula'

class Fish < Formula
  homepage 'http://fishshell.com'
  url 'http://fishshell.com/files/2.0.0/fish-2.0.0.tar.gz'
  sha1 '2d28553e2ff975f8e5fed6b266f7a940493b6636'

  head 'https://github.com/fish-shell/fish-shell.git'

  # Indeed, the head build always builds documentation
  depends_on 'doxygen' => :build if build.head?
  depends_on :autoconf

  skip_clean 'share/doc'

  conflicts_with "fishfish"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells. Run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end
end
