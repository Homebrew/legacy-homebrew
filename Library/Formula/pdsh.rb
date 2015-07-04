class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://code.google.com/p/pdsh/"
  url "https://code.google.com/p/pdsh.git",
      :tag => "pdsh-2.31",
      :revision => "e1c8e71dd6a26b40cd067a8322bd14e10e4f7ded"

  head "https://code.google.com/p/pdsh.git"

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
