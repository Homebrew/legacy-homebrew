class EucjpMecabIpadicRequirement < Requirement
  fatal true

  def initialize(tags = [])
    super
    @mecab_ipadic_installed = Formula["mecab-ipadic"].installed?
  end

  satisfy(:build_env => false) { @mecab_ipadic_installed && mecab_dic_charset == "euc" }

  def message
    if @mecab_ipadic_installed
      <<-EOS.undent
        Hyper Estraier supports only the EUC-JP version of MeCab-IPADIC.
        However, you have installed the #{mecab_dic_charset} version so far.

        You have to reinstall your mecab-ipadic package manually with the
        --with-charset=euc option before resuming the hyperestraier installation,
        or you have to build hyperestraier without MeCab support.

        To reinstall your mecab-ipadic and resume the hyperestraier installation:

            $ brew uninstall mecab-ipadic
            $ brew install mecab-ipadic --with-charset=euc
            $ brew install hyperestraier --enable-mecab

        To build hyperestraier without MeCab support:

            $ brew install hyperestraier
      EOS
    else
      <<-EOS.undent
        An EUC-JP version of MeCab-IPADIC is required. You have to install your
        mecab-ipadic package manually with the --with-charset=euc option before
        resuming the hyperestraier installation, or you have to build hyperestraier
        without MeCab support.

        To install an EUC-JP version of mecab-ipadic and resume the hyperestraier
        installation:

            $ brew install mecab-ipadic --with-charset=euc
            $ brew install hyperestraier --enable-mecab

        To build hyperestraier without MeCab support:

            $ brew install hyperestraier
      EOS
    end
  end

  def mecab_dic_charset
    /^charset:\t(\S+)$/ =~ `mecab -D` && Regexp.last_match[1]
  end
end

class Hyperestraier < Formula
  desc "Full-text search system for communities"
  homepage "http://fallabs.com/hyperestraier/index.html"
  url "http://fallabs.com/hyperestraier/hyperestraier-1.4.13.tar.gz"
  sha256 "496f21190fa0e0d8c29da4fd22cf5a2ce0c4a1d0bd34ef70f9ec66ff5fbf63e2"

  depends_on "qdbm"
  depends_on "mecab" => :optional

  if build.with? "mecab"
    depends_on "mecab-ipadic"
    depends_on EucjpMecabIpadicRequirement
  end

  deprecated_option "enable-mecab" => "with-mecab"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-mecab" if build.with? "mecab"

    system "./configure", *args
    system "make", "mac"
    system "make", "check-mac"
    system "make", "install-mac"
  end

  test do
    system "#{bin}/estcmd", "version"
  end
end
