require 'formula'

class EucjpMecabIpadic < Requirement
  fatal true

  def initialize
    @mecab_ipadic_installed = Formula['mecab-ipadic'].installed?
  end

  satisfy { @mecab_ipadic_installed && mecab_dic_charset == 'euc' }

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
    /^charset:\t(\S+)$/ =~ `mecab -D` && $1
  end
end

class Hyperestraier < Formula
  homepage 'http://fallabs.com/hyperestraier/index.html'
  url 'http://fallabs.com/hyperestraier/hyperestraier-1.4.13.tar.gz'
  sha1 '1094686f457070323083ecf4f89665c564a0c5f0'

  option 'enable-mecab', 'Include MeCab support'

  depends_on 'qdbm'

  if build.include? 'enable-mecab'
    depends_on 'mecab'
    depends_on 'mecab-ipadic'
    depends_on EucjpMecabIpadic
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << '--enable-mecab' if build.include? 'enable-mecab'

    system "./configure", *args
    system "make mac"
    system "make check-mac"
    system "make install-mac"
  end

  test do
    system "#{bin}/estcmd", "version"
  end
end
