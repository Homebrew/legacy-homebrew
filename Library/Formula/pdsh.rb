class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://code.google.com/p/pdsh/"
  url "https://code.google.com/p/pdsh.git",
      :tag => "pdsh-2.31",
      :revision => "e1c8e71dd6a26b40cd067a8322bd14e10e4f7ded"

  head "https://code.google.com/p/pdsh.git"

  bottle do
    sha256 "a48664745214479e43afbcb75a35cb2c1056a8036b13e2ff5e757c603db03eb0" => :yosemite
    sha256 "7a994ac4f24950407b46d3d97758d60d5b9ae94b23d8b308a3a9139a7db4efc1" => :mavericks
    sha256 "a40070aef9be5f23d6a739bcff1f143cff3123ac50c7c8801874797f6011578f" => :mountain_lion
  end

  option "without-dshgroups", "This option should be specified to load genders module first"

  depends_on "readline"
  depends_on "genders" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssh
      --without-rsh
      --with-nodeupdown
      --with-readline
      --without-xcpu
    ]

    args << "--with-genders" if build.with? "genders"
    args << ((build.without? "dshgroups") ? "--without-dshgroups" : "--with-dshgroups")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
