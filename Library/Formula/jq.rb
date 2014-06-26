require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.io/jq/'
  url 'http://stedolan.github.io/jq/download/source/jq-1.4.tar.gz'
  sha1 '71da3840839ec74ae65241e182ccd46f6251c43e'

  depends_on 'bison' => :build # jq depends on bison > 2.5

  head do
    url 'https://github.com/stedolan/jq.git'

    depends_on 'oniguruma'
    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/jq .bar", "w+") do |pipe|
      pipe.puts '{"foo":1, "bar":2}'
      pipe.close_write
      assert_equal "2\n", pipe.read
    end
  end
end
