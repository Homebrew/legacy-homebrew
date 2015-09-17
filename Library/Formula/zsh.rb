class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "http://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.1.1/zsh-5.1.1.tar.gz"
  mirror "http://www.zsh.org/pub/zsh-5.1.1.tar.gz"
  sha256 "94ed5b412023761bc8d2f03c173f13d625e06e5d6f0dff2c7a6e140c3fa55087"

  bottle do
    sha256 "1509f461b1dee825cb66183409c04820f71e559c116201c4073ccd97eeb67704" => :el_capitan
    sha256 "ef2e5dd13668edd59725b6a320db7513a6635ec7d3fd30891eb4e87ace6887e8" => :yosemite
    sha256 "313444fc801db870fce3855e3ecda1f8a63aa24e44aaa448805d2dd61e62d584" => :mavericks
    sha256 "78563c521de6861a2278f8e9d44aa8eac86e5c699d0d75018f805ec34286c9cd" => :mountain_lion
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"

  deprecated_option "disable-etcdir" => "without-etcdir"

  depends_on "gdbm"
  depends_on "pcre"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{share}/zsh/functions
      --enable-scriptdir=#{share}/zsh/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{share}/zsh/help
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

    if build.without? "etcdir"
      args << "--disable-etcdir"
    else
      args << "--enable-etcdir=/etc"
    end

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make", "install"
    system "make", "install.info"
  end

  def caveats; <<-EOS.undent
    Add the following to your zshrc to access the online help:
      unalias run-help
      autoload run-help
      HELPDIR=#{HOMEBREW_PREFIX}/share/zsh/help
    EOS
  end

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
