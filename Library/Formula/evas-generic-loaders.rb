class EvasGenericLoaders < Formula
  homepage "https://enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.14.0-beta1.tar.gz"
  sha256 "787570a63ef59004942b24e9dd28d4e66396c45dcebda105d9f6dfa4b1b6ee16"

  depends_on 'pkg-config' => :build
  depends_on 'efl'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test evas_generic_loaders`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end
