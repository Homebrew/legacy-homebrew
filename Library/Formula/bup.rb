class Bup < Formula
  desc "Backup tool"
  homepage "https://github.com/bup/bup"
  head "https://github.com/bup/bup.git"

  stable do
    url "https://github.com/bup/bup/archive/0.26.tar.gz"
    sha256 "8c25551fa723cfe5dcaaa671c5f0964d8caff22b068923df007a13169d8f015c"

    # Fix compilation on 10.10
    patch do
      url "https://github.com/bup/bup/commit/75d089e7cdb7a7eb4d69c352f56dad5ad3aa1f97.diff"
      sha256 "9a4615e91b7b2f43e5447e30aa4096f1b0bf65dc2081e7c08d852830ee217716"
    end
  end

  option "with-tests", "Run unit tests after compilation"
  option "with-pandoc", "Build and install the manpages"

  deprecated_option "run-tests" => "with-tests"

  depends_on "pandoc" => [:optional, :build]

  def install
    system "make"
    system "make", "test" if build.with? "tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end

  test do
    system bin/"bup", "init"
    assert File.exist?("#{testpath}/.bup")
  end
end
