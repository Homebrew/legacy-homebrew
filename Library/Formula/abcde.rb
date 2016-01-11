class Abcde < Formula
  desc "Better CD Encoder"
  homepage "http://abcde.einval.com"
  revision 1

  head "http://git.einval.com/git/abcde.git"

  stable do
    url "http://abcde.einval.com/download/abcde-2.7.1.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.7.1.orig.tar.gz"
    sha256 "3401e39785b20edee843d4d875b47d2b559f764681c482c4491a8c8ba605f250"

    # Fix "Expansion of $REDIR quoted on MacOSX breaks cp" bug
    # (http://abcde.einval.com/bugzilla/show_bug.cgi?id=22)
    # Obsolete once a new version is released as upstream already merged this
    # patch in c024365a846faae390f23c86f32235d6209e6edf
    # (http://git.einval.com/cgi-bin/gitweb.cgi?p=abcde.git;a=commit;h=c024365a846faae390f23c86f32235d6209e6edf)
    patch do
      url "http://abcde.einval.com/bugzilla/attachment.cgi?id=12"
      sha256 "4620dd5ef7ab32b6511782da85831661ccee292fadff1f58acc3b4992486af62"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "91bebd8a7c17518bfc99f2b8067234024fe012205f2d5d0e193eb64dd2882fc5" => :el_capitan
    sha256 "f553e4ef30cdc2a3a7f01f4874d98cc3fbcb5fb4dabd2ee36496ad7fff2cec89" => :yosemite
    sha256 "754737e1e8adaa267e77f1cec57e414e9e7d4598fe24f3428cc4ad07d280994b" => :mavericks
  end

  depends_on "cd-discid"
  depends_on "cdrtools"
  depends_on "id3v2"
  depends_on "mkcue"
  depends_on "flac" => :optional
  depends_on "lame" => :optional
  depends_on "vorbis-tools" => :optional
  depends_on "glyr" => :optional

  def install
    system "make", "install", "prefix=#{prefix}", "etcdir=#{etc}"
  end

  test do
    system "#{bin}/abcde", "-v"
  end
end
